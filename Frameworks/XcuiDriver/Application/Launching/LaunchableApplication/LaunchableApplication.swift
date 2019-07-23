import MixboxUiTestsFoundation

public protocol LaunchableApplication: class {
    var legacyNetworking: LegacyNetworking { get }
    
    func launch(
        arguments: [String],
        environment: [String: String])
        -> LaunchedApplication
    
    func terminate()
}
