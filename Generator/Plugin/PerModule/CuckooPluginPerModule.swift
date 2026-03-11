import Foundation
import PackagePlugin

@main
struct CuckooPluginPerModule: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let sourceModules: [SourceModule] = target.dependencies
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
            .filter { $0.kind == ModuleKind.generic && $0.moduleName != "Cuckoo" }
            .map { module in
                SourceModule(
                    name: module.moduleName,
                    sources: module.sourceFiles.filter { $0.type == .source }.map(\.url)
                )
            }

        return try commandsPerModule(
            sourceModules: sourceModules,
            executableFactory: context.tool(named:),
            projectDir: context.package.directoryURL,
            derivedSourcesDir: context.pluginWorkDirectoryURL
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension CuckooPluginPerModule: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let sourceModules: [SourceModule] = target.dependencies
            .flatMap { dependency in
                switch dependency {
                case .product(let product):
                    return product.targets
                        .compactMap { $0 as? SwiftSourceModuleTarget }
                        .filter { $0.kind == ModuleKind.generic && $0.moduleName != "Cuckoo" }
                        .map { module in
                            SourceModule(
                                name: module.moduleName,
                                sources: module.sourceFiles.filter { $0.type == .source }.map(\.url)
                            )
                        }
                case .target(let target):
                    guard target.displayName != "Cuckoo" else { return [] }
                    return [SourceModule(
                        name: target.displayName,
                        sources: target.inputFiles.filter { $0.type == .source }.map(\.url)
                    )]
                @unknown default:
                    return []
                }
            }

        return try commandsPerModule(
            sourceModules: sourceModules,
            executableFactory: context.tool(named:),
            projectDir: context.xcodeProject.directoryURL,
            derivedSourcesDir: context.pluginWorkDirectoryURL
        )
    }
}
#endif

struct SourceModule {
    let name: String
    let sources: [URL]
}

private func commandsPerModule(
    sourceModules: [SourceModule],
    executableFactory: (String) throws -> PluginContext.Tool,
    projectDir: URL,
    derivedSourcesDir: URL
) throws -> [Command] {
    let configurationURL = projectDir.appending(path: "Cuckoofile.toml")
    let executable = try executableFactory("CuckooGenerator").url

    return sourceModules.map { sourceModule in
        let outputURL = derivedSourcesDir.appending(component: "GeneratedMocks_\(sourceModule.name).swift")

        return .buildCommand(
            displayName: "Run Cuckoonator for \(sourceModule.name)",
            executable: executable,
            arguments: [],
            environment: [
                "PROJECT_DIR": projectDir.path(),
                "DERIVED_SOURCES_DIR": derivedSourcesDir.path(),
                "CUCKOO_OVERRIDE_OUTPUT": outputURL.path(),
                "CUCKOO_MODULE_NAME": sourceModule.name,
            ],
            inputFiles: [configurationURL] + sourceModule.sources,
            outputFiles: [outputURL]
        )
    }
}
