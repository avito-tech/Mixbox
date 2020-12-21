import MixboxTestsFoundation

// These declaration duplicate interface of Cuckoo,
// they are not set in stone and are just for compatibility during migration period.

@discardableResult
public func stub<M: Mock>(_ mock: M, block: (M.StubbingBuilder) -> ()) -> M  {
    block(mock.stub())
    return mock
}

public func when<Arguments, ReturnType>(
    _ stubbingFunctionBuilder: StubbingFunctionBuilder<Arguments, ReturnType>)
    -> StubbingFunctionBuilder<Arguments, ReturnType>
{
    stubbingFunctionBuilder
}

extension Mock {
    @discardableResult
    public static func stub<M: Mock>(_ mock: M, block: (M.StubbingBuilder) -> ()) -> M {
        return MixboxMocksRuntime.stub(mock, block: block)
    }
}

public func anyClosure<MatchingType>() -> Matcher<MatchingType> {
    return any()
}

public func equals<MatchingType>(
    _ value: MatchingType,
    when: (MatchingType) -> Bool)
    -> Matcher<MatchingType>
    where
    MatchingType: Equatable
{
    return matches { other in value == other }
}
