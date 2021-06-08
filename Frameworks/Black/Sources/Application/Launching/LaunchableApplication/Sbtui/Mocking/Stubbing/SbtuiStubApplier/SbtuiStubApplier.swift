public protocol SbtuiStubApplier: AnyObject {
    func apply(stub: SbtuiStub)
    func removeAllStubs()
}
