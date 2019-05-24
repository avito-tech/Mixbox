public protocol EnvironmentProvider {
    var environment: [String: String] { get }
}
