import MixboxFoundation

public final class InteractionPerformingSettings {
    public let failTest: Bool
    public let fileLine: FileLine
    
    public init(
        failTest: Bool,
        fileLine: FileLine)
    {
        self.failTest = failTest
        self.fileLine = fileLine
    }
}
