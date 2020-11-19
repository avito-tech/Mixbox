import MixboxFoundation

public protocol MockType: class {
    var mockManager: MockManager { get }
    func setMockManager(mockManager: MockManager)
    
    associatedtype StubBuilder: MixboxMocksRuntime.StubBuilder
    associatedtype ExpectationBuilder: MixboxMocksRuntime.ExpectationBuilder
}

extension MockType {
    public func expect(
        file: StaticString = #file,
        line: UInt = #line)
        -> ExpectationBuilder
    {
        return ExpectationBuilder(
            mockManager: mockManager,
            times: MixboxMocksRuntime.atLeast(1),
            fileLine: FileLine(file: file, line: line)
        )
    }
    
    public func expect<T: Matcher>(
        times: T,
        file: StaticString = #file,
        line: UInt = #line)
        -> ExpectationBuilder
        where
        T.MatchingType == Int
    {
        return ExpectationBuilder(
            mockManager: mockManager,
            times: MixboxMocksRuntime.FunctionalMatcher(matcher: times),
            fileLine: FileLine(file: file, line: line)
        )
    }
    
    public func stub() -> StubBuilder {
        return StubBuilder(mockManager: mockManager)
    }
    
    @discardableResult
    public func verify() -> MixboxMocksRuntimeVoid {
        _ = mockManager.verify()
        return MixboxMocksRuntime.MixboxMocksRuntimeVoid()
    }
}
