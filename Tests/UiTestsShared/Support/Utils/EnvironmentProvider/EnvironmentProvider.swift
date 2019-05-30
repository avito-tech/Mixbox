public protocol EnvironmentProvider: class {
    var environment: [String: String] { get }
}
