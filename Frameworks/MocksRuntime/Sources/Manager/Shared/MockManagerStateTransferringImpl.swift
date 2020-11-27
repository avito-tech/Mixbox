public final class MockManagerStateTransferringImpl: MockManagerStateTransferring {
    private let stubsProvider: StubsProvider
    private let recordedCallsHolder: RecordedCallsHolder
    
    public init(
        stubsProvider: StubsProvider,
        recordedCallsHolder: RecordedCallsHolder)
    {
        self.stubsProvider = stubsProvider
        self.recordedCallsHolder = recordedCallsHolder
    }
    
    public func transferState(to mockManager: MockManager) {
        stubsProvider.stubs.forEach { functionIdentifier, stubs in
            stubs.forEach { callStub in
                mockManager.stub(
                    functionIdentifier: functionIdentifier,
                    callStub: callStub
                )
            }
        }
        
        mockManager.appendRecordedCalls(from: recordedCallsHolder)
    }
    
    public func appendRecordedCalls(from recordedCallsProvider: RecordedCallsProvider) {
        recordedCallsHolder.recordedCalls.append(
            contentsOf: recordedCallsProvider.recordedCalls
        )
    }
}
