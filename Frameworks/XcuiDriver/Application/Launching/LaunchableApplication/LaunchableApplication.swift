import MixboxUiTestsFoundation

public protocol LaunchableApplication: class {
    var networking: Networking { get }
    
    func launch(
        arguments: [String],
        environment: [String: String])
        -> LaunchedApplication
    
    func terminate()
}
