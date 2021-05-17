public protocol RecordedCallsHolder: RecordedCallsProvider {
    // Applies `modify` block to recordedCalls and return it. Thread-safe.
    @discardableResult
    func modifyRecordedCalls(
        modify: (inout [RecordedCall]) -> ())
        -> [RecordedCall]
}

extension RecordedCallsHolder {
    public var recordedCalls: [RecordedCall] {
        modifyRecordedCalls { _ in }
    }
}
