import PackagePlugin
import Foundation

@main struct CuckooPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [PackagePlugin.Command] {
        let configPath = context.package.directory.appending("cuckoo-config.json")
        let config = try await ConfigFile.decode(from: configPath)

        let dependencies: [SourceModuleTarget] = target
            .dependencies
            .flatMap { dependency in
                switch dependency {
                case .product(let product):
                    return product.targets
                case .target(let target):
                    return [target]
                @unknown default:
                    return []
                }
            }
            .compactMap { $0 as? SourceModuleTarget }
            .filter { $0.kind == .generic && $0.moduleName != "Cuckoo" }

        let testableModules = dependencies
            .map(\.moduleName)
            .joined(separator: ",")

        let sources = dependencies
            .flatMap(\.sourceFiles)
            .filter { $0.type == .source }
            .map(\.path)

        let output = context.pluginWorkDirectory.appending("GeneratedMocks.swift")

        return [.buildCommand(
            displayName: "Run CuckooGenerator",
            executable: try context.tool(named: "CuckooGenerator").path,
            arguments: [
                "generate",
                "--output", output,
                "--testable", testableModules
            ] + config.options + sources,
            inputFiles: [configPath] + sources,
            outputFiles: [output]
        )]
    }
}

struct ConfigFile: Codable {
    enum Version: Int, Codable {
        case v1 = 1
    }

    var version: Version = .v1
    var options: [String] = []

    static func decode(from path: Path) async throws -> Self {
        guard let data = try? await path.contents() else { return .init() }
        return try JSONDecoder().decode(self, from: data)
    }
}

extension Path {
    func contents() async throws -> Data {
        let url: URL
        if #available(macOS 13, *) {
            url = URL(filePath: string)
        } else {
            url = URL(fileURLWithPath: string)
        }
        if #available(macOS 12, *) {
            return try await url.resourceBytes.reduce(into: Data()) { $0.append($1) }
        } else {
            return try Data(contentsOf: url)
        }
    }
}
