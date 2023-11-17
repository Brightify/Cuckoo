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
            sources: sources.map(\.path),
            executableFactory: context.tool(named:),
            projectDir: context.package.directory,
            derivedSourcesDir: context.pluginWorkDirectory
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
            sources: sources.map(\.path),
            executableFactory: context.tool(named:),
            projectDir: context.xcodeProject.directory,
            derivedSourcesDir: context.pluginWorkDirectory
        )
    }
}
#endif

func commands(
    sources: [Path],
    executableFactory: (String) throws -> PluginContext.Tool,
    projectDir: Path,
    derivedSourcesDir: Path
) throws -> [Command] {
    let configurationPath = projectDir.appending("Cuckoofile.toml")
    let output = derivedSourcesDir.appending("GeneratedMocks.swift")
    return [
        .buildCommand(
            displayName: "Run Cuckoonator (single file)",
            executable: try executableFactory("CuckooGenerator").path,
            arguments: [],
            environment: [
                "PROJECT_DIR": projectDir,
                "DERIVED_SOURCES_DIR": derivedSourcesDir,
                "CUCKOO_OVERRIDE_OUTPUT": output,
            ],
            inputFiles: [configurationPath] + sources,
            outputFiles: [output]
        )
    ]
}
