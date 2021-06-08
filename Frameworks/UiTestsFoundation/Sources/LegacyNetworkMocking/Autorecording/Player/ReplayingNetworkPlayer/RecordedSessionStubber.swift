public protocol RecordedSessionStubber: AnyObject {
    func stub(
        recordedStub: RecordedStub)
        throws
    
    func stubAllNetworkInitially()
}
