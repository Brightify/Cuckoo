import Foundation
import FileKit

struct FileHeaderHandler {
    static func header(for file: FileRepresentation, timestamp: String?) -> String {
        let path = getRelativePath(to: file)
        return [
            "// MARK: - Mocks generated from file: '\(path)'",
            timestamp.map { "at \($0)" },
        ]
        .compactMap { $0 }
        .joined(separator: " ")
    }

    static func imports(
        for file: FileRepresentation,
        imports: [String],
        publicImports: [String],
        testableImports: [String]
    ) -> String {
        [
            !publicImports.contains("Cuckoo") ? ["import Cuckoo"] : [],
            OrderedSet(file.imports.map { $0.description } + imports).values
                .filter { !testableImports.contains($0) }
                .map { "import \($0)" },
            publicImports.map { "public import \($0)" },
            testableImports.map { "@testable import \($0)" },
        ]
        .flatMap { $0 }
        .joined(separator: "\n")
    }

    private static func getRelativePath(to file: FileRepresentation) -> String {
        let path = file.file.path.absolute
        let base = path.commonAncestor(Path.current)
        let components = path.components.suffix(from: base.components.endIndex)
        let result = components.map { $0.rawValue }.joined(separator: Path.separator)
        let difference = Path.current.components.endIndex - base.components.endIndex
        return (0..<difference).reduce(result) { acc, _ in ".." + Path.separator + acc }
    }
}
