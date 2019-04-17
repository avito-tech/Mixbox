import MixboxUiTestsFoundation

public protocol LaunchableApplication {
    var networking: Networking { get }
    
    func launch(
        arguments: [String],
        environment: [String: String])
        -> LaunchedApplication
    
    func terminate()
}
