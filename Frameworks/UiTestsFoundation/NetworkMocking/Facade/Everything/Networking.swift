// Facade for mocking and stubbing Network, ready to use from UI tests
public protocol Networking: class {
    var stubbing: NetworkStubbing { get }
    var recording: NetworkRecording { get }
}
