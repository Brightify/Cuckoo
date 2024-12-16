import ProjectDescription

public extension Optional<Environment.Value> {
    func requireString(message: String, isEnabled: Bool = true) -> EnvironmentVariable {
        if case .string(let value) = self {
            return EnvironmentVariable.environmentVariable(value: value, isEnabled: isEnabled)
        } else {
            fatalError(message)
        }
    }
}
