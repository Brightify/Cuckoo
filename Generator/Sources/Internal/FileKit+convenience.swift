import FileKit

extension Path {
    func relative(to path: Path) -> Path {
        relative(to: path.rawValue)
    }

    func relative(to path: String) -> Path {
        if isAbsolute {
            return self
        } else {
            return path + self
        }
    }

    func relative(to path: String?) -> Path? {
        if isAbsolute {
            return self
        } else {
            guard let path else { return nil }
            return Path(path) + self
        }
    }
}
