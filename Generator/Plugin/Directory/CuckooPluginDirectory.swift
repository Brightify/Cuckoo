import Foundation
import PackagePlugin

// FIXME: Xcode complains that prebuild commands can't use executable targets – a prebuild command cannot use executables built from source, including executable target 'CuckooGenerator'
// FIXME: So I'll leave the code here, but unfortunately it's not usable in the current state.
@main
struct CuckooPluginDirectory: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        FileManager.default.forceClean(directory: context.pluginWorkDirectory)

        return try commands(
            executableFactory: context.tool(named:),
            projectDir: context.package.directory,
            derivedSourcesDir: context.pluginWorkDirectory
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension CuckooPluginDirectory: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        FileManager.default.forceClean(directory: context.pluginWorkDirectory)

        return try commands(
            executableFactory: context.tool(named:),
            projectDir: context.xcodeProject.directory,
            derivedSourcesDir: context.pluginWorkDirectory
        )
    }
}
#endif

func commands(
    executableFactory: (String) throws -> PluginContext.Tool,
    projectDir: Path,
    derivedSourcesDir: Path
) throws -> [Command] {
    let configurationPath = projectDir.appending("Cuckoofile.toml")
    let output = derivedSourcesDir
    return [
        .prebuildCommand(
            displayName: "Run Cuckoonator (individual files)",
            executable: try executableFactory("CuckooGenerator").path,
            arguments: [],
            environment: [
                "PROJECT_DIR": projectDir,
                "DERIVED_SOURCES_DIR": derivedSourcesDir,
                "CUCKOO_OVERRIDE_OUTPUT": output.string,
            ],
            outputFilesDirectory: output
        ),
    ]
}

private extension FileManager {
    /// Re-create the given directory
    func forceClean(directory: Path) {
        try? removeItem(atPath: directory.string)
        try? createDirectory(atPath: directory.string, withIntermediateDirectories: false)
    }
}
