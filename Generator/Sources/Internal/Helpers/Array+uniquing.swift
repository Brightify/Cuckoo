import Foundation

extension Array where Element: Hashable {
    func uniquing() -> [Element] {
        OrderedSet(self).values
    }
}
