import Foundation
import XCTest

final class VersionTest: XCTestCase {
    func testGeneratorVersionMatchesLibraryVersion() throws {
        let repositoryURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let libraryVersion = try String(
            contentsOf: repositoryURL.appendingPathComponent("version"),
            encoding: .utf8
        ).trimmingCharacters(in: .whitespacesAndNewlines)

        XCTAssertEqual(version, libraryVersion)
    }
}
