public final class NoopInteractionFailureDebugger: InteractionFailureDebugger {
    public init() {
    }
    
    public func performDebugging() -> InteractionFailureDebuggingResult {
        return .failureWasNotFixed
    }
}
