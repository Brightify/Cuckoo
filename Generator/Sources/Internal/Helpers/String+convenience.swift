import Foundation

extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}

extension String {
    subscript(range: NSRange) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: range.location)
        let toIndex = self.index(fromIndex, offsetBy: range.length)
        return String(self[fromIndex..<toIndex])
    }
}

extension String {
    func stringMatch(from match: NSTextCheckingResult, at range: Int = 0) -> String {
        let matchRange = match.range(at: range)
        let fromIndex = index(startIndex, offsetBy: matchRange.location)
        let toIndex = index(fromIndex, offsetBy: matchRange.length)
        return String(self[fromIndex..<toIndex])
    }

    func removing(match: NSTextCheckingResult, at range: Int = 0) -> String {
        let matchRange = match.range(at: range)
        let fromIndex = index(startIndex, offsetBy: matchRange.location)
        let toIndex = index(fromIndex, offsetBy: matchRange.length)

        var mutableString = self
        mutableString.removeSubrange(fromIndex..<toIndex)
        return mutableString
    }
}
