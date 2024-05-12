import Foundation

extension String {
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func takeUntil(occurence: String) -> String? {
        return components(separatedBy: occurence).first
    }

    subscript(range: Range<Int>) -> String {
        let stringRange = index(startIndex, offsetBy: range.lowerBound)..<index(startIndex, offsetBy: range.upperBound)
        return String(self[stringRange])
    }
}

extension String.UTF8View {
    subscript(range: Range<Int>) -> String {
        let stringRange = index(startIndex, offsetBy: range.lowerBound)..<index(startIndex, offsetBy: range.upperBound)
        let subsequence: String.UTF8View.SubSequence = self[stringRange]
        return String(subsequence) ?? ""
    }
}

extension String {
    func regexMatches(_ source: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: self)
        return regex.firstMatch(in: source, range: NSRange(location: 0, length: source.count)) != nil
    }
}
