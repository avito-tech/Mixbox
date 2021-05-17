import Foundation

public final class StubsHolderImpl: StubsHolder {
    public typealias Stubs = [FunctionIdentifier: [CallStub]]
    
    private let lock = NSLock()
    private var unsynchronizedStubs: Stubs = [:]
    
    public init() {
    }
    
    @discardableResult
    public func modifyStubs(
        modify: (inout Stubs) -> ())
        -> Stubs
    {
        return lock.lockWhile {
            modify(&unsynchronizedStubs)
            
            return unsynchronizedStubs
        }
    }
}
