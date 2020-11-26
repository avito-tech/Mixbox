// Transfers all state from one MockManager to another.
public protocol MockManagerStateTransferring {
    func transferState(to mockManager: MockManager)
    func appendCallRecords(from callRecordsProvider: CallRecordsProvider)
}
