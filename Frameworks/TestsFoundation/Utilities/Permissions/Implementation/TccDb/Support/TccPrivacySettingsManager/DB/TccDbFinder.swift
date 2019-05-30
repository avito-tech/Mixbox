// Searches for TCC.db of current simulator
public protocol TccDbFinder: class {
    func tccDbPath() throws -> String
}

public final class TccDbFinderImpl: TccDbFinder {
    private let currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider
    
    public init(currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider) {
        self.currentSimulatorFileSystemRootProvider = currentSimulatorFileSystemRootProvider
    }
    
    public func tccDbPath() throws -> String {
        return try currentSimulatorFileSystemRootProvider
            .currentSimulatorFileSystemRoot()
            .osxPath("data/Library/TCC/TCC.db")
    }
}
