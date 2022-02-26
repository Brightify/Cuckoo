protocol HasAccessibility: Token {
    var accessibility: Accessibility { get set }
}

extension HasAccessibility {
    var areAllHierarchiesAccessible: Bool {
        guard accessibility.isAccessible else { return false }
        var parent: Token? = parent?.value
        while let p = parent as? HasAccessibility {
            guard p.accessibility.isAccessible else { return false }
            parent = p.parent?.value
        }
        return true
    }
}
