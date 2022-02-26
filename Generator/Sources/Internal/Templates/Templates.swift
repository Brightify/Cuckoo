import Foundation

struct Templates { }

extension String {
    func indented(times: Int = 1) -> String {
        let indentation = String(repeating: "    ", count: times)

        return self.components(separatedBy: CharacterSet.newlines).map {
            indentation + $0
        }.joined(separator: "\n")
    }
}
