import MixboxFoundation

public final class SimulatorFileSystemRoot {
    public let osxRoot: String
    
    public init(osxRoot: String) {
        self.osxRoot = osxRoot
    }
    
    // Finds file in simulator.
    // Example of `pathRelativeToSimulator`: "data/Documents".
    public func osxPath(_ pathRelativeToSimulator: String) -> String {
        return osxRoot.mb_appendingPathComponent(pathRelativeToSimulator)
    }
}
