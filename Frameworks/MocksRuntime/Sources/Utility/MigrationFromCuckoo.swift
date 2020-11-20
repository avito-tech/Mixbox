// These declaration duplicate interface of Cuckoo,
// they are not set in stone and are just for compatibility during migration period.

public func stub<M: Mock>(_ mock: M, block: (M.StubbingBuilder) -> ()) {
    block(mock.stub())
}

public func when<M: Mock>(_ mock: M, block: (M) -> ()) {
    block(mock)
}
