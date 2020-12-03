import MixboxFoundation

public final class TccDbFinderImpl: TccDbFinder {
    private let currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider
    
    public init(currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider) {
        self.currentSimulatorFileSystemRootProvider = currentSimulatorFileSystemRootProvider
    }
    
    public func tccDbPath() throws -> String {
        do {
            return try currentSimulatorFileSystemRootProvider
                .currentSimulatorFileSystemRoot()
                .osxPath("data/Library/TCC/TCC.db")
        } catch {
            throw ErrorString("Failed to `tccDbPath()`: \(error)")
        }
    }
}
