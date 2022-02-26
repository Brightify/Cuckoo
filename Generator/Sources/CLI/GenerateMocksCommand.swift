import Foundation
import Commandant
import Result
import FileKit

struct GenerateMocksCommand: CommandProtocol {
    typealias TokenFilter = (Token) -> Bool

    let verb = "generate"
    let function = "Generates mock files"

    func run(_ options: Options) -> Result<Void, CuckooGeneratorError> {
        let inputPathValues: [String]
        if options.isGlobEnabled {
            inputPathValues = options.files.flatMap { Glob(pattern: $0).paths }
        } else {
            inputPathValues = options.files
        }
        let sortedInputPathValues = Array(Set(inputPathValues.map { Path($0).standardRawValue })).sorted()

        let inputFiles = sortedInputPathValues
            .map { Path($0) }
            .filter { $0.exists }
            .map(TextFile.init(path:))

        let files: [FileRepresentation] = inputFiles.compactMap { file in
            guard let crawler = try? Crawler.crawl(url: file.path.url) else { return nil }
            return FileRepresentation(file: file, imports: crawler.imports, tokens: crawler.tokens)
        }
        let flatMappedFiles = files.map { $0.flatMappingMemberContainers() }
        let finalFiles = options.noInheritance ? flatMappedFiles : inheritNSObject(mergingInheritance(flatMappedFiles))

        // filter classes/protocols based on the settings passed to the generator
        var typeFilters: [TokenFilter] = []
        if options.noClassMocking {
            typeFilters.append(ignoreClasses)
        }
        if !options.regex.isEmpty {
            typeFilters.append(keepMatching(pattern: options.regex))
        }
        if !options.exclude.isEmpty {
            typeFilters.append(ignoreExcluded(in: options.exclude))
        }
        let parsedFiles = removeTypes(from: finalFiles, using: typeFilters)
        let mockableFiles = parsedFiles.map { $0.replacing(tokens: $0.tokens.filter { $0.isMockable }) }

        let timestamp = options.noTimestamp || options.noHeader ? nil : Date().description
        let generatedFileContents = try! mockableFiles.map { file in
            [
                options.noHeader ? nil : FileHeaderHandler.header(for: file, timestamp: timestamp),
                FileHeaderHandler.imports(for: file, testableFrameworks: options.testableFrameworks),
                try Generator.generate(tokens: file.tokens, debug: options.isDebug),
            ]
            .compactMap { $0 }
            .joined(separator: "\n\n")
        }

        do {
            let outputPath = Path(options.output)
            if outputPath.isDirectory {
                let inputPaths = inputFiles.map { $0.path }
                for (inputPath, outputText) in zip(inputPaths, generatedFileContents) {
                    let fileName = options.filePrefix + inputPath.fileName
                    let outputFile = TextFile(path: outputPath + fileName)
                    try outputFile.write(outputText)
                }
            } else {
                let outputFile = TextFile(path: outputPath)
                try outputFile.write(generatedFileContents.joined(separator: "\n\n"))
            }
        } catch let error as FileKitError {
            return .failure(.ioError(error))
        } catch {
            return .failure(.unknownError(error))
        }

        return .success(())
    }

    private func mergingInheritance(_ filesRepresentation: [FileRepresentation]) -> [FileRepresentation] {
        filesRepresentation.compactMap { $0.mergingInheritance(with: filesRepresentation) }
    }

    private func inheritNSObject(_ filesRepresentation: [FileRepresentation]) -> [FileRepresentation] {
        func containsRecursively(name: String) -> Bool {
            guard let protocolDeclaration = protocolDeclarationDictionary[name] else { return false }
            let collapsedInheritedTypesName = protocolDeclaration.inheritedTypes
            if collapsedInheritedTypesName.contains(where: { $0 == "NSObjectProtocol" }) {
                return true
            } else {
                return protocolDeclaration.inheritedTypes.contains { inheritanceType in
                    containsRecursively(name: inheritanceType)
                }
            }
        }

        let protocolDeclarationDictionary: [String: ProtocolDeclaration] = Dictionary(
            uniqueKeysWithValues: filesRepresentation.flatMap { file in
                file.tokens.compactMap { token -> (name: String, protocolDeclaration: ProtocolDeclaration)? in
                    guard let protocolDeclaration = token as? ProtocolDeclaration else { return nil }
                    return (name: protocolDeclaration.name, protocolDeclaration: protocolDeclaration)
                }
            }
        )

        let nsObjectProtocols: [ProtocolDeclaration] = protocolDeclarationDictionary.values.reduce(into: []) { protocols, protocolDeclaration in
            guard containsRecursively(name: protocolDeclaration.name) else { return }
            protocols.append(protocolDeclaration)
        }

        return filesRepresentation.map { $0.inheritNSObject(protocols: nsObjectProtocols) }
    }

    private func removeTypes(from files: [FileRepresentation], using filters: [TokenFilter]) -> [FileRepresentation] {
        // Only keep those that pass all filters
        let filter: TokenFilter = { token in
            guard token.isClass || token.isProtocol else { return true }
            return !filters.contains { !$0(token) }
        }

        return files.compactMap { file in
            let filteredTokens = file.tokens.filter(filter)
            guard !filteredTokens.isEmpty else { return nil }
            return file.replacing(tokens: filteredTokens)
        }
    }

    // filter that keeps the protocols while removing all classes
    private func ignoreClasses(token: Token) -> Bool {
        !token.isClass
    }

    // filter that keeps the classes/protocols that match the passed regular expression
    private func keepMatching(pattern: String) -> TokenFilter {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])

            return { token in
                guard let namedToken = token as? HasName else { return true }
                return regex.firstMatch(in: namedToken.name, options: [], range: NSMakeRange(0, namedToken.name.count)) != nil
            }
        } catch {
            fatalError("Invalid regular expression: " + (error as NSError).description)
        }
    }

    // filter that keeps only the classes/protocols that are not supposed to be excluded
    private func ignoreExcluded(in excluded: [String]) -> TokenFilter {
        let excludedSet = Set(excluded)
        return { token in
            guard let containerToken = token as? ContainerToken else { return true }
            return !excludedSet.contains(containerToken.name)
        }
    }


    struct Options: OptionsProtocol {
        let files: [String]
        let output: String
        let noHeader: Bool
        let noTimestamp: Bool
        let noInheritance: Bool
        let testableFrameworks: [String]
        let exclude: [String]
        let filePrefix: String
        let noClassMocking: Bool
        let isDebug: Bool
        let isGlobEnabled: Bool
        let regex: String

        init(
            output: String,
            testableFrameworks: String,
            exclude: String,
            noHeader: Bool,
            noTimestamp: Bool,
            noInheritance: Bool,
            filePrefix: String,
            noClassMocking: Bool,
            isDebug: Bool,
            isGlobEnabled: Bool,
            regex: String,
            files: [String]
        ) {
            self.output = output
            self.testableFrameworks = testableFrameworks.components(separatedBy: ",").filter { !$0.isEmpty }
            self.exclude = exclude.components(separatedBy: ",").filter { !$0.isEmpty }.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            self.noHeader = noHeader
            self.noTimestamp = noTimestamp
            self.noInheritance = noInheritance
            self.filePrefix = filePrefix
            self.noClassMocking = noClassMocking
            self.isDebug = isDebug
            self.isGlobEnabled = isGlobEnabled
            self.regex = regex
            self.files = files
        }

        // all options are declared here and then parsed by Commandant
        static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<CuckooGeneratorError>> {
            let output: Result<String, CommandantError<ClientError>> = m <| Option(key: "output", defaultValue: "GeneratedMocks.swift", usage: "Where to put the generated mocks.\nIf a path to a directory is supplied, each input file will have a respective output file with mocks.\nIf a path to a Swift file is supplied, all mocks will be in a single file.\nDefault value is `GeneratedMocks.swift`.")

            let testable: Result<String, CommandantError<ClientError>> = m <| Option(key: "testable", defaultValue: "", usage: "A comma separated list of frameworks that should be imported as @testable in the mock files.")

            let exclude: Result<String, CommandantError<ClientError>> = m <| Option(key: "exclude", defaultValue: "", usage: "A comma separated list of classes and protocols that should be skipped during mock generation.")

            let noHeader: Result<Bool, CommandantError<ClientError>> = m <| Option(key: "no-header", defaultValue: false, usage: "Do not generate file headers.")

            let noTimestamp: Result<Bool, CommandantError<ClientError>> = m <| Option(key: "no-timestamp", defaultValue: false, usage: "Do not generate timestamp.")

            let noInheritance: Result<Bool, CommandantError<ClientError>> = m <| Option(key: "no-inheritance", defaultValue: false, usage: "Do not generate stubs/mock for super class/protocol even if available.")

            let filePrefix: Result<String, CommandantError<ClientError>> = m <| Option(key: "file-prefix", defaultValue: "", usage: "Names of generated files in directory will start with this prefix. Only works when output path is directory.")

            let noClassMocking: Result<Bool, CommandantError<ClientError>> = m <| Option(key: "no-class-mocking", defaultValue: false, usage: "Do not generate mocks for classes.")

            let isDebug: Result<Bool, CommandantError<ClientError>> = m <| Switch(flag: "d", key: "debug", usage: "Run generator in debug mode.")

            let isGlobEnabled: Result<Bool, CommandantError<ClientError>> = m <| Switch(flag: "g", key: "glob", usage: "Use glob for specifying input paths.")

            let regex: Result<String, CommandantError<ClientError>> = m <| Option(key: "regex", defaultValue: "", usage: "A regular expression pattern that is used to match Classes and Protocols.\nAll that do not match are excluded.\nCan be used alongside `--exclude`.")

            let input: Result<[String], CommandantError<ClientError>> = m <| Argument(usage: "Files to parse and generate mocks for.")

            // If you want to add an option, make sure to extend the `curry` function below.

            return curry(Options.init)
                <*> output
                <*> testable
                <*> exclude
                <*> noHeader
                <*> noTimestamp
                <*> noInheritance
                <*> filePrefix
                <*> noClassMocking
                <*> isDebug
                <*> isGlobEnabled
                <*> regex
                <*> input
        }
    }
}

// Unfortunately, Swift doesn't support variadic generic parameters as of now, so this monstrosity is necessary.
private func curry<P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, R>
    (_ f: @escaping (P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12) -> R)
    ->(P1)->(P2)->(P3)->(P4)->(P5)->(P6)->(P7)->(P8)->(P9)->(P10)->(P11)->(P12) -> R {
        return { p1 in { p2 in { p3 in { p4 in { p5 in { p6 in { p7 in { p8 in { p9 in { p10 in { p11 in { p12 in
            f(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
        } } } } } } } } } } } }
}
