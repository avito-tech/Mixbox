import MixboxIpcCommon

public protocol UrlProtocolStubAdder: AnyObject {
    func addStub(
        bridgedUrlProtocolClass: BridgedUrlProtocolClass)
        throws
        -> AddedUrlProtocolStub
}
