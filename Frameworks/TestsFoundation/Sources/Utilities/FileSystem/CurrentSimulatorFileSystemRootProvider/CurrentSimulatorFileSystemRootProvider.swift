public protocol CurrentSimulatorFileSystemRootProvider: class {
    func currentSimulatorFileSystemRoot() throws -> SimulatorFileSystemRoot
}
