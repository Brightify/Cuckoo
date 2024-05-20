import ProjectDescription

public extension Optional<Environment.Value> {
    func requireString(message: String) -> String {
        if case .string(let value) = self {
            return value
        } else {
            fatalError(message)
        }
    }

    func requireBool(message: String) -> Bool {
        if case .boolean(let value) = self {
            return value
        } else {
            fatalError(message)
        }
    }
}
