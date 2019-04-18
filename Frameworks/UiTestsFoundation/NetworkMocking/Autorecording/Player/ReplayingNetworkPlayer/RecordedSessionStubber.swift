public protocol RecordedSessionStubber {
    func stub(
        recordedStub: RecordedStub)
        throws
    
    func stubAllNetworkInitially()
}
