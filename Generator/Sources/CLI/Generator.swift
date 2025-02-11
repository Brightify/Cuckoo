import Foundation
@preconcurrency import FileKit
import XcodeProj
import Rainbow

final class Generator {
    typealias TokenFilter = (Token) -> Bool
    
    struct GeneratedFile {
        let path: Path
        let contents: String
    }

    static func generate(for module: Module, verbose: Bool) async throws -> [GeneratedFile] {
        let xcodeprojSources = try getXcodeprojPaths(from: module)

        if xcodeprojSources != nil && module.sources != nil {
            log(.info, message: "\("\(module.name).xcodeproj".bold) was defined along with \("sources".bold), both file lists will be merged.")
        }
        let sources = [module.sources, xcodeprojSources].compactMap { $0 }.flatMap { $0 }

        let inputPathValues: [Path]
        if module.options.glob {
            inputPathValues = sources.flatMap { Glob(pattern: $0.description).paths.map { Path($0) } }
        } else {
            inputPathValues = sources
        }
        let sortedInputPathValues = Set(inputPathValues.map { $0.standardRawValue }).sorted()

        let inputFiles = sortedInputPathValues
            .map { Path($0) }
            .filter { $0.exists }
            .map(TextFile.init(path:))

        let files: [FileRepresentation] = await inputFiles.concurrentCompactMap { file in
            do {
                log(.verbose, message: "Processing file: \(file.path)")
                let crawler = try Crawler.crawl(url: file.path.url)
                log(.verbose, message: "Successfully processed file: \(file.path)")
                return FileRepresentation(file: file, imports: crawler.imports, tokens: crawler.tokens)
            } catch {
                log(.error, message: "Failed to crawl file at '\(file.path)':", error)
                return nil
            }
        }
        let flatMappedFiles = files.map { $0.flatMappingMemberContainers() }
        let finalFiles = if module.options.enableInheritance {
            inheritNSObject(mergingInheritance(flatMappedFiles))
        } else {
            flatMappedFiles
        }

        // filter classes/protocols based on the settings passed to the generator
        var typeFilters: [TokenFilter] = []
        if module.options.protocolsOnly {
            typeFilters.append(ignoreClasses)
        }
        if let regex = module.regex {
            typeFilters.append(try keepMatching(pattern: regex))
        }
        if !module.exclude.isEmpty {
            typeFilters.append(ignoreExcluded(in: module.exclude))
        }
        let parsedFiles = removeTypes(from: finalFiles, using: typeFilters)
        let mockableFiles = parsedFiles.map { $0.replacing(tokens: $0.tokens.filter { $0.isMockable }) }

        let timestamp = verbose ? Date().description : nil
        return try await mockableFiles.concurrentMap { file in
            await GeneratedFile(
                path: file.file.path,
                contents: [
                    module.options.omitHeaders ? nil : FileHeaderHandler.header(for: file, timestamp: timestamp),
                    FileHeaderHandler.imports(for: file, imports: module.imports, publicImports: module.publicImports, testableImports: module.testableImports),
                    try GeneratorHelper.generate(tokens: file.tokens),
                ]
                .compactMap { $0 }
                .joined(separator: "\n\n")
            )
        }
    }

    private static func getXcodeprojPaths(from module: Module) throws -> [Path]? {
        guard let xcodeprojData = module.xcodeproj else { return nil }
        let xcodeprojPath: Path
        if xcodeprojData.path.isDirectory && xcodeprojData.path.pathExtension != "xcodeproj" {
            let xcodeprojs = xcodeprojData.path.find(searchDepth: 0) { path in
                path.pathExtension == "xcodeproj"
            }
            guard let xcodeproj = xcodeprojs.first else {
                throw GeneratorError.noXcodeproj(xcodeprojData.path)
            }
            guard xcodeprojs.count == 1 else {
                throw GeneratorError.multipleXcodeprojs(xcodeprojs.map(\.fileName))
            }
            xcodeprojPath = xcodeproj
        } else {
            xcodeprojPath = xcodeprojData.path
        }
        let xcodeproj = try XcodeProj(path: .init(xcodeprojPath.rawValue))
        let targets = xcodeproj.pbxproj.targets(named: xcodeprojData.target)
        guard let target = targets.first else {
            throw GeneratorError.noXcodeprojTarget(xcodeprojPath, targetName: xcodeprojData.target)
        }
        guard targets.count == 1 else {
            throw GeneratorError.multipleXcodeprojTargets(xcodeprojPath, targetName: xcodeprojData.target, count: targets.count)
        }
        return try target.sourceFiles()
            .compactMap { try $0.fullPath(sourceRoot: xcodeprojPath.rawValue) }
            .map { Path($0) }
    }

    private static func mergingInheritance(_ filesRepresentation: [FileRepresentation]) -> [FileRepresentation] {
        filesRepresentation.compactMap { $0.mergingInheritance(with: filesRepresentation) }
    }

    private static func inheritNSObject(_ filesRepresentation: [FileRepresentation]) -> [FileRepresentation] {
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
            filesRepresentation.flatMap { file in
                file.tokens.compactMap { token -> (name: String, protocolDeclaration: ProtocolDeclaration)? in
                    guard let protocolDeclaration = token as? ProtocolDeclaration else { return nil }
                    return (name: protocolDeclaration.name, protocolDeclaration: protocolDeclaration)
                }
            }
        ) { former, latter in
            log(.info, message: "Duplicate protocol '\(former.name)' in source set, behavior is undefined.")
            return latter
        }

        let nsObjectProtocols: [ProtocolDeclaration] = protocolDeclarationDictionary.values.reduce(into: []) { protocols, protocolDeclaration in
            guard containsRecursively(name: protocolDeclaration.name) else { return }
            protocols.append(protocolDeclaration)
        }

        return filesRepresentation.map { $0.inheritNSObject(protocols: nsObjectProtocols) }
    }

    private static func removeTypes(from files: [FileRepresentation], using filters: [TokenFilter]) -> [FileRepresentation] {
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
    private static func ignoreClasses(token: Token) -> Bool {
        !token.isClass
    }

    // filter that keeps the classes/protocols that match the passed regular expression
    private static func keepMatching(pattern: String) throws -> TokenFilter {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])

            return { token in
                guard let namedToken = token as? HasName else { return true }
                return regex.firstMatch(in: namedToken.name, options: [], range: NSMakeRange(0, namedToken.name.count)) != nil
            }
        } catch {
            throw GeneratorError.invalidRegex(pattern, error: error)
        }
    }

    // filter that keeps only the classes/protocols that are not supposed to be excluded
    private static func ignoreExcluded(in excluded: [String]) -> TokenFilter {
        let excludedSet = Set(excluded)
        return { token in
            guard let containerToken = token as? ContainerToken else { return true }
            return !excludedSet.contains(containerToken.name)
        }
    }

    enum GeneratorError: Error, CustomStringConvertible {
        case invalidRegex(String, error: Error)
        case noXcodeproj(Path)
        case multipleXcodeprojs([String])
        case noXcodeprojTarget(Path, targetName: String)
        case multipleXcodeprojTargets(Path, targetName: String, count: Int)

        var description: String {
            switch self {
            case .invalidRegex(let regex, let error):
                return "Invalid regular expression \"\(regex.bold)\" because \(error.localizedDescription)."
            case .noXcodeproj(let path):
                return "Couldn't find any project in directory \(path.rawValue.bold)."
            case .multipleXcodeprojs(let xcodeprojNames):
                return "Couldn't automatically select project among \(xcodeprojNames.map { $0.bold }.joined(separator: ", "))."
            case .noXcodeprojTarget(let path, let targetName):
                return "Couldn't find any target named \(targetName.bold) in project \(path.rawValue.bold)."
            case .multipleXcodeprojTargets(let path, let targetName, let count):
                return "Found \(String(count).bold) targets named \(targetName.bold) in project \(path.rawValue.bold)."
            }
        }
    }
}


