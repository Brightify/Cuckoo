import XCTest

enum TestError: Error {
    case unknown

    static func errorCheck(file: StaticString = #file, line: UInt = #line) -> (Error) -> Void {
        return {
            if $0 is TestError {
            } else {
                XCTFail("Expected TestError, got: \(type(of: $0))(\($0.localizedDescription))", file: file, line: line)
            }
        }
    }
}
