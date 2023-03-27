import PackagePlugin

@main struct CuckooPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [PackagePlugin.Command] {
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
                "--testable", testableModules,
                "--regex", "Mockable.*"
            ] + sources,
            inputFiles: sources,
            outputFiles: [output]
        )]
    }
}
