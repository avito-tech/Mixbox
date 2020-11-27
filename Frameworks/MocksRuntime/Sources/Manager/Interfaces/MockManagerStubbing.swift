public protocol MockManagerStubbing {
    func stub(
        functionIdentifier: FunctionIdentifier,
        callStub: CallStub)
}
