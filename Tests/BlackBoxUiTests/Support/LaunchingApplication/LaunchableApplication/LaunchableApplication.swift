import MixboxUiTestsFoundation

public protocol LaunchableApplication {
    var networking: Networking { get }
    
    func launch(environment: [String: String]) -> LaunchedApplication
}
