import MixboxUiTestsFoundation

public final class XcuiApplicationQuiescenceWaiter: ApplicationQuiescenceWaiter {
    public init() {
    }
    
    public func waitForQuiescence<T>(body: () throws -> T) throws -> T {
        // Do not do anything. Every access to AX hierarchy occurs with waiting for quiescence.
        // There is no reason to do anything specific here, it will only affect performance negatively.
        
        return try body()
    }
}
