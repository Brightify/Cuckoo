import Foundation
import ArgumentParser
import TOMLKit
@preconcurrency import FileKit

@main
@available(macOS 12, *)
struct GenerateCommand: AsyncParsableCommand {
    nonisolated(unsafe) static var configuration = CommandConfiguration(
        commandName: "Generate",
        abstract: "Cuckoo CLI tool for generating mocks according to the specified configuration.",
        version: version,
        helpNames: .shortAndLong
    )

    @Option(
        name: [.customLong("configuration")],
        help: "Set Cuckoofile path. By default the Cuckoonator looks for it in the project root.",
        completion: .file()
    )
    var configurationPath: String?

    @Flag(help: "Include extra information during generation and in the generated code.")
    var verbose = false

    private var overriddenOutput: String?

    mutating func run() async throws {
        Logger.shared.logLevel = verbose ? .verbose : .info

        let projectDir = ProcessInfo.processInfo.environment["PROJECT_DIR"]
        let configurationFile = [
            configurationPath.map { Path($0) }?.relative(to: projectDir)?.rawValue,
            projectDir.map { "\($0)/Cuckoofile.toml" },
            "\(FileManager.default.currentDirectoryPath)/Cuckoofile.toml",
        ]
        .lazy
        .compactMap { pathString -> (path: Path, contents: String)? in
            guard let pathString else { return nil }
            let path = Path(pathString, expandingTilde: true)
            guard let contents = try? String(contentsOfFile: path.rawValue, encoding: .utf8) else { return nil }
            return (path: path, contents: contents)
        }
        .first

        guard let configurationFile else { throw GenerateError.missingConfiguration }

        log(.info, message: "Using configuration file at path:", configurationFile.path)

        overriddenOutput = ProcessInfo.processInfo.environment["CUCKOO_OVERRIDE_OUTPUT"]
        Module.overriddenOutput = overriddenOutput

        let modules = try modules(
            configurationPath: configurationFile.path,
            contents: configurationFile.contents
        )

        // To not capture mutating self.
        let verbose = self.verbose

        await modules.concurrentForEach { module in
            do {
                let generatedFiles = try await Generator.generate(for: module, verbose: verbose)
                let outputPath = Path(module.output, expandingTilde: true)
                let absoluteOutputPath: Path
                if outputPath.isAbsolute {
                    absoluteOutputPath = outputPath
                } else {
                    absoluteOutputPath = configurationFile.path.parent + outputPath
                }
                let isOutputDirectory: Bool
                if absoluteOutputPath.exists && absoluteOutputPath.isDirectory {
                    isOutputDirectory = true
                } else {
                    isOutputDirectory = absoluteOutputPath.pathExtension.isEmpty
                    // Create directory structure.
                    if isOutputDirectory {
                        try absoluteOutputPath.createDirectory(withIntermediateDirectories: true)
                    } else {
                        try absoluteOutputPath.parent.createDirectory(withIntermediateDirectories: true)
                    }
                }
                if isOutputDirectory {
                    await generatedFiles.concurrentForEach { generatedFile in
                        let originalFileName = generatedFile.path.fileNameWithoutExtension
                        let fileNameWithoutExtension = module.filenameFormat
                            .map { $0.replacingOccurrences(of: "{}", with: originalFileName) }
                            ?? originalFileName
                        let outputFile = TextFile(path: absoluteOutputPath + "\(fileNameWithoutExtension).swift")
                        do {
                            try outputFile.write(generatedFile.contents)
                        } catch {
                            log(.error, message: "Failed to write to file '\(outputFile)':", error)
                        }
                    }
                } else {
                    let outputFile = TextFile(path: absoluteOutputPath)
                    do {
                        try outputFile.write(generatedFiles.map(\.contents).joined(separator: "\n\n"))
                    } catch {
                        log(.error, message: "Failed to write to file '\(outputFile)':", error)
                    }
                }
            } catch {
                log(.error, message: "Failed to generate mocks for module \(module.name):", error)
            }
        }
    }

    func modules(configurationPath: Path, contents: String) throws -> [Module] {
        var errorMessages: [String] = []
        var globalOutput: String? = overriddenOutput
        var modules: [Module] = []
        let table = try TOMLTable(string: contents)

        // Sorting to make sure global properties are evaluated first to be available as fallbacks.
        let sortedTable = table.sorted { lhs, rhs in
            let (_, lhsValue) = lhs
            let (_, rhsValue) = rhs
            switch (lhsValue.type, rhsValue.type) {
            case (.table, .table):
                return true
            case (.table, _):
                return false
            case (_, .table):
                return true
            default:
                return true
            }
        }

        let decoder = TOMLDecoder()
        for (key, value) in sortedTable {
            switch key {
            case "output":
                if globalOutput == nil {
                    log(.verbose, message: "Global output:", globalOutput as Any)
                    globalOutput = value.string
                } else {
                    errorMessages.append("Multiple global `output` parameters. Behavior is undefined.")
                }
            case "modules":
                guard let modulesTable = value.table else {
                    throw GenerateError.modulesMustBeTable
                }
                for (moduleName, innards) in modulesTable {
                    guard let moduleTable = innards.table else {
                        throw GenerateError.modulesMustBeTable
                    }
                    let dto = try decoder.decode(Module.DTO.self, from: moduleTable)
                    do {
                        let module = try Module(
                            name: moduleName,
                            output: globalOutput,
                            configurationPath: configurationPath,
                            dto: dto
                        )
                        log(.verbose, message: "Module \(moduleName):", module)
                        modules.append(module)
                    } catch {
                        errorMessages.append(String(describing: error))
                    }
                }
            default:
                continue
            }
        }

        guard errorMessages.isEmpty else {
            throw GenerateError.configurationErrors(details: errorMessages)
        }

        return modules
    }

    private enum GenerateError: Error, CustomStringConvertible {
        case missingConfiguration
        case modulesMustBeTable
        case configurationErrors(details: [String])

        static func configurationError(_ detail: String) -> GenerateError {
            .configurationErrors(details: [detail])
        }

        var description: String {
            switch self {
            case .missingConfiguration:
                return """
                Failed to find Cuckoofile configuration.
                Expected in project folder through $PROJECT_DIR or in the same directory where the Cuckoonator was called.
                """
            case .modulesMustBeTable:
                return """
                Modules must be TOML tables. Define them as \("[modules.ModuleName]".bold) with properties beneath.
                """
            case .configurationErrors(let details):
                return """
                Cuckoofile contains errors:
                \(details.map { "\t- \($0)" }.joined(separator: "\n"))
                """
            }
        }
    }
}
