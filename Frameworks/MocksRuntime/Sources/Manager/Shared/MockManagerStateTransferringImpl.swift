public final class MockManagerStateTransferringImpl: MockManagerStateTransferring {
    private let stubsProvider: StubsProvider
    private let callRecordsHolder: CallRecordsHolder
    
    public init(
        stubsProvider: StubsProvider,
        callRecordsHolder: CallRecordsHolder)
    {
        self.stubsProvider = stubsProvider
        self.callRecordsHolder = callRecordsHolder
    }
    
    public func transferState(to mockManager: MockManager) {
        stubsProvider.stubs.forEach { functionIdentifier, stubs in
            stubs.forEach { stub in
                mockManager.stub(
                    functionIdentifier: functionIdentifier,
                    closure: stub.closure,
                    argumentsMatcher: stub.matcher
                )
            }
        }
        
        mockManager.appendCallRecords(from: callRecordsHolder)
    }
    
    public func appendCallRecords(from callRecordsProvider: CallRecordsProvider) {
        callRecordsHolder.callRecords.append(
            contentsOf: callRecordsProvider.callRecords
        )
    }
}
