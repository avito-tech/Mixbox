public protocol RecordedSessionStubber: class {
    func stub(
        recordedStub: RecordedStub)
        throws
    
    func stubAllNetworkInitially()
}
