import Foundation

public private(set) var stderrUsed = false

func stderrPrint(_ item: Any) {
    stderrUsed = true
    fputs("error: \(item)\n", stderr)
}
