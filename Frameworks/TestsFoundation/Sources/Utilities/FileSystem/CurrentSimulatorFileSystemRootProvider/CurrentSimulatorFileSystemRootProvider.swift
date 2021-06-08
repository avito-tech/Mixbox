public protocol CurrentSimulatorFileSystemRootProvider: AnyObject {
    func currentSimulatorFileSystemRoot() throws -> SimulatorFileSystemRoot
}
