import SwiftIfConfig
import SwiftSyntax

/// A BuildConfiguration implementation for the Cuckoo generator that evaluates `#if` conditions
/// based on user-supplied custom conditions and sensible defaults for known platform/compiler queries.
struct CuckooGeneratorBuildConfiguration: BuildConfiguration {
    /// Custom conditions set via `-D` flags (e.g. `-D DEBUG`).
    let customConditions: Set<String>

    func isCustomConditionSet(name: String) throws -> Bool {
        customConditions.contains(name)
    }

    func hasFeature(name: String) throws -> Bool {
        false
    }

    func hasAttribute(name: String) throws -> Bool {
        false
    }

    func canImport(importPath: [(TokenSyntax, String)], version: CanImportVersion) throws -> Bool {
        false
    }

    func isActiveTargetOS(name: String) throws -> Bool {
        false
    }

    func isActiveTargetArchitecture(name: String) throws -> Bool {
        false
    }

    func isActiveTargetEnvironment(name: String) throws -> Bool {
        false
    }

    func isActiveTargetRuntime(name: String) throws -> Bool {
        false
    }

    func isActiveTargetPointerAuthentication(name: String) throws -> Bool {
        false
    }

    var targetPointerBitWidth: Int { 64 }

    var targetAtomicBitWidths: [Int] { [32, 64] }

    var endianness: Endianness { .little }

    var languageVersion: VersionTuple { VersionTuple(6, 0) }

    var compilerVersion: VersionTuple { VersionTuple(6, 0) }
}
