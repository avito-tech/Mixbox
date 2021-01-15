// Facade for mocking and stubbing Network, ready to use from UI tests
// Note: will be removed some time after SBTUITestTunnel is removed.
// There is no alternative to this class yet.
public protocol LegacyNetworking: class {
    var stubbing: LegacyNetworkStubbing { get }
    var recording: LegacyNetworkRecording { get }
}
