import Foundation
import FileKit

final class Module: @unchecked Sendable {
    nonisolated(unsafe) static var overriddenOutput: String?

    let name: String
    let imports: [String]
    let publicImports: [String]
    let testableImports: [String]
    let sources: [Path]?
    let exclude: [String]
    let regex: String?
    let output: String
    let filenameFormat: String?
    let options: Options
    let xcodeproj: Xcodeproj?

    init(name: String, output: String?, configurationPath: Path, dto: DTO) throws {
        guard Module.overriddenOutput != nil || output != nil || dto.output != nil else {
            throw ModuleInitError.missingOutput(name: name)
        }

        self.name = name
        self.imports = dto.imports?.map(\.trimmed) ?? []
        self.publicImports = dto.publicImports?.map(\.trimmed) ?? []
        self.testableImports = dto.testableImports?.map(\.trimmed) ?? []
        self.sources = dto.sources?.map(\.trimmed).map { source in
            Path(source, expandingTilde: true).relative(to: configurationPath.parent)
        }
        self.exclude = dto.exclude?.map(\.trimmed) ?? []
        self.regex = dto.regex
        self.output = (Module.overriddenOutput ?? dto.output ?? output)!
        self.filenameFormat = dto.filenameFormat
        self.options = Options(
            glob: dto.options?.glob ?? true,
            keepDocumentation: dto.options?.keepDocumentation ?? true,
            enableInheritance: dto.options?.enableInheritance ?? true,
            protocolsOnly: dto.options?.protocolsOnly ?? false,
            omitHeaders: dto.options?.omitHeaders ?? false
        )

        if let xcodeproj = dto.xcodeproj {
            if let target = xcodeproj.target {
                self.xcodeproj = Xcodeproj(
                    path: xcodeproj.path.map {
                        Path($0, expandingTilde: true).relative(to: configurationPath.parent)
                    } ?? configurationPath.parent,
                    target: target
                )
            } else {
                throw ModuleInitError.missingXcodeprojTarget
            }
        } else {
            xcodeproj = nil
        }

        if let filenameFormat, !filenameFormat.contains("{}") {
            throw ModuleInitError.wrongFilenameFormat
        }
    }

    struct Options {
        let glob: Bool
        let keepDocumentation: Bool
        let enableInheritance: Bool
        let protocolsOnly: Bool
        let omitHeaders: Bool
    }

    struct Xcodeproj {
        let path: Path
        let target: String
    }

    enum ModuleInitError: Error, CustomStringConvertible {
        case missingOutput(name: String)
        case wrongFilenameFormat
        case missingXcodeprojTarget

        var description: String {
            switch self {
            case .missingOutput(let moduleName):
                return "Missing `output` parameter in module \(moduleName). Either define a global `output` or add `output` to the module."
            case .wrongFilenameFormat:
                return "Filename format must contain \"{}\" to denote where to put the base filename."
            case .missingXcodeprojTarget:
                return "xcodeproj.target is required"
            }
        }
    }
}

extension Module {
    struct DTO: Decodable {
        let imports: [String]?
        let publicImports: [String]?
        let testableImports: [String]?
        let sources: [String]?
        let exclude: [String]?
        let regex: String?
        let output: String?
        let filenameFormat: String?
        let options: Options?
        let xcodeproj: Xcodeproj?

        struct Options: Decodable {
            let glob: Bool?
            let keepDocumentation: Bool?
            let enableInheritance: Bool?
            let protocolsOnly: Bool?
            let omitHeaders: Bool?
        }

        struct Xcodeproj: Decodable {
            let path: String?
            let target: String?
        }
    }
}

extension Module: CustomDebugStringConvertible {
    var debugDescription: String {
        [
            "imports:\(imports.map { "\n\t-\($0.bold)" }.joined(separator: ", "))",
            "public imports:\(publicImports.map { "\n\t-\($0.bold)" }.joined(separator: ", "))",
            "testable imports:\(testableImports.map { "\n\t-\($0.bold)" }.joined(separator: ", "))",
            sources.map { "sources:\($0.map { "\n\t-\($0.rawValue.bold)" }.joined())" },
            "excluded types:\(exclude.map { "\n\t-\($0.bold)" }.joined())",
            regex.map { "regex: \($0.bold)" },
            "output: \(output.bold)",
            filenameFormat.map { "filename format: \($0.bold)" },
            "options:\(options.debugDescription.components(separatedBy: "\n").map { "\n\t- \($0)" }.joined())",
            xcodeproj.map { "xcodeproj:\($0.debugDescription.components(separatedBy: "\n").map { "\n\t- \($0)" }.joined())" },
        ]
        .compactMap { $0 }
        .joined(separator: "\n")
    }
}

extension Module.Options: CustomDebugStringConvertible {
    var debugDescription: String {
        [
            "glob: \(String(glob).bold)",
            "keep documentation: \(String(keepDocumentation).bold)",
            "enable inheritance: \(String(enableInheritance).bold)",
            "protocols only: \(String(protocolsOnly).bold)",
            "omit headers: \(String(omitHeaders).bold)",
        ]
        .compactMap { $0 }
        .joined(separator: "\n")
    }
}

extension Module.Xcodeproj: CustomDebugStringConvertible {
    var debugDescription: String {
        [
            "path: \(path.rawValue.bold)",
            "target: \(target.bold)",
        ]
        .compactMap { $0 }
        .joined(separator: "\n")
    }
}
