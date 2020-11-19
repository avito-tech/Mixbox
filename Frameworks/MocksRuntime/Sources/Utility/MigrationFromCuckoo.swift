// These declaration duplicate interface of Cuckoo,
// they are not set in stone and are just for compatibility during migration period.

public func stub<M: MockType>(_ mock: M, block: (M.StubBuilder) -> ()) {
    block(mock.stub())
}
