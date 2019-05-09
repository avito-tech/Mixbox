public protocol CurrentSimulatorFileSystemRootProvider {
    func currentSimulatorFileSystemRoot() throws -> SimulatorFileSystemRoot
}
