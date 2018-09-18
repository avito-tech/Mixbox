// Searches for TCC.db of current simulator
final class TccDbFinder {
    func tccDbPath() -> String? {
        return SimulatorFileSystemRoot.current?.osxPath("data/Library/TCC/TCC.db")
    }
}
