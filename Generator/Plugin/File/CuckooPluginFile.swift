import Foundation
import PackagePlugin

@main
struct CuckooPluginFile: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let sources: [FileList.Element] = target.dependencies
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
            .flatMap(\.sourceFiles)
            .filter { $0.type == .source }

        return try commands(
            sources: sources.map(\.url),
            executableFactory: context.tool(named:),
            projectDir: context.package.directoryURL,
            derivedSourcesDir: context.pluginWorkDirectoryURL
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension CuckooPluginFile: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let sources: [FileList.Element] = target.dependencies
            .flatMap { dependency in
                switch dependency {
                case .product(let product):
                    return product.targets
                        .compactMap { $0 as? SwiftSourceModuleTarget }
                        .filter { $0.kind == ModuleKind.generic && $0.moduleName != "Cuckoo" }
                        .flatMap(\.sourceFiles)
                        .filter { $0.type == .source }
                case .target(let target):
                    guard target.displayName != "Cuckoo" else { return [] }
                    return target.inputFiles.filter { $0.type == .source }
                @unknown default:
                    return []
                }
            }

        return try commands(
            sources: sources.map(\.url),
            executableFactory: context.tool(named:),
            projectDir: context.xcodeProject.directoryURL,
            derivedSourcesDir: context.pluginWorkDirectoryURL
        )
    }
}
#endif

func commands(
    sources: [URL],
    executableFactory: (String) throws -> PluginContext.Tool,
    projectDir: URL,
    derivedSourcesDir: URL
) throws -> [Command] {
    let configurationURL = projectDir.appending(path: "Cuckoofile.toml")
    let outputURL = derivedSourcesDir.appending(component: "GeneratedMocks.swift")

    return [
        .buildCommand(
            displayName: "Run Cuckoonator (single file)",
            executable: try executableFactory("CuckooGenerator").url,
            arguments: [],
            environment: [
                "PROJECT_DIR": projectDir.path(),
                "DERIVED_SOURCES_DIR": derivedSourcesDir.path(),
                "CUCKOO_OVERRIDE_OUTPUT": outputURL.path(),
            ],
            inputFiles: [configurationURL] + sources,
            outputFiles: [outputURL]
        )
    ]
}
