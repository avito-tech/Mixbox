public protocol InteractionFailureDebugger {
    func performDebugging() throws -> InteractionFailureDebuggingResult
}
