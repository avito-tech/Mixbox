import MixboxUiTestsFoundation

public protocol LaunchableApplication: AnyObject {
    var legacyNetworking: LegacyNetworking { get }
    
    func launch(
        arguments: [String],
        environment: [String: String])
        -> LaunchedApplication
    
    func terminate()
}
