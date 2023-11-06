import Foundation
import FileKit

final class Module {
    let name: String
    let imports: [String]
    let testableImports: [String]
    let sources: [Path]
    let exclude: [String]
    let regex: String?
    let output: String
    let filenameFormat: String?
    let options: Options

    init(name: String, output: String?, configurationPath: Path, dto: DTO) throws {
        guard output != nil || dto.output != nil else {
            throw ModuleInitError.missingOutput(name: name)
        }

        self.name = name
        self.imports = dto.imports?.map(\.trimmed) ?? []
        self.testableImports = dto.testableImports?.map(\.trimmed) ?? []
        self.sources = dto.sources.map(\.trimmed).map { source in
            let path = Path(source, expandingTilde: true)
            if path.isAbsolute {
                return path
            } else {
                return configurationPath.parent + path
            }
        }
        self.exclude = dto.exclude?.map(\.trimmed) ?? []
        self.regex = dto.regex
        self.output = (output ?? dto.output)!
        self.filenameFormat = dto.filenameFormat
        self.options = Options(
            glob: dto.options?.glob ?? true,
            keepDocumentation: dto.options?.keepDocumentation ?? true,
            noInheritance: dto.options?.noInheritance ?? false,
            noClassMocking: dto.options?.noClassMocking ?? false,
            noHeaders: dto.options?.noHeaders ?? false
        )

        if let filenameFormat, !filenameFormat.contains("{}") {
            throw ModuleInitError.wrongFilenameFormat
        }
    }

    struct Options {
        let glob: Bool
        let keepDocumentation: Bool
        let noInheritance: Bool
        let noClassMocking: Bool
        let noHeaders: Bool
    }

    enum ModuleInitError: Error, CustomStringConvertible {
        case missingOutput(name: String)
        case wrongFilenameFormat

        var description: String {
            switch self {
            case .missingOutput(let moduleName):
                return "Missing `output` parameter in module \(moduleName). Either define a global `output` or add `output` to the module."
            case .wrongFilenameFormat:
                return "Filename format must contain \"{}\" to denote where to put the base filename."
            }
        }
    }
}

extension Module {
    struct DTO: Decodable {
        let imports: [String]?
        let testableImports: [String]?
        let sources: [String]
        let exclude: [String]?
        let regex: String?
        let output: String?
        let filenameFormat: String?
        var options: Options?

        struct Options: Decodable {
            let glob: Bool?
            let keepDocumentation: Bool?
            let noInheritance: Bool?
            let noClassMocking: Bool?
            let noHeaders: Bool?
        }
    }
}
