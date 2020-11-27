// Transfers all state from one MockManager to another.
public protocol MockManagerStateTransferring {
    func transferState(to mockManager: MockManager)
    func appendRecordedCalls(from recordedCallsProvider: RecordedCallsProvider)
}
