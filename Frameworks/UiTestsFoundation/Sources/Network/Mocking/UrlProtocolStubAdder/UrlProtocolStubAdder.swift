import MixboxIpcCommon

public protocol UrlProtocolStubAdder: class {
    func addStub(
        bridgedUrlProtocolClass: BridgedUrlProtocolClass)
        throws
        -> AddedUrlProtocolStub
}
