public final class ClosureAddedUrlProtocolStub: AddedUrlProtocolStub {
    public typealias RemoveImpl = () -> ()
    
    private let removeImpl: RemoveImpl
    
    public init(
        removeImpl: @escaping RemoveImpl)
    {
        self.removeImpl = removeImpl
    }
    
    public func remove() {
        removeImpl()
    }
}
