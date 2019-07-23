// Facade for mocking and stubbing Network, ready to use from UI tests
public protocol LegacyNetworking: class {
    var stubbing: LegacyNetworkStubbing { get }
    var recording: LegacyNetworkRecording { get }
}
