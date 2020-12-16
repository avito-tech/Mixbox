import MixboxFoundation

// Note: don't add properties to protocols to avoid name collisions.
// Properties don't support overloading.
public protocol Mock: StorableMock, DefaultImplementationSettable {
    associatedtype StubbingBuilder: MixboxMocksRuntime.StubbingBuilder
    associatedtype VerificationBuilder: MixboxMocksRuntime.VerificationBuilder
}

extension Mock {
    public func verify(file: StaticString = #file, line: UInt = #line) -> VerificationBuilder {
        return VerificationBuilder(
            mockManager: getMockManager(MixboxMocksRuntimeVoid.self),
            fileLine: FileLine(
                file: file,
                line: line
            )
        )
    }
    
    public func stub(file: StaticString = #file, line: UInt = #line) -> StubbingBuilder {
        return StubbingBuilder(
            mockManager: getMockManager(MixboxMocksRuntimeVoid.self),
            fileLine: FileLine(
                file: file,
                line: line
            )
        )
    }
    
    public func getMockInfo(_: MixboxMocksRuntimeVoid.Type) -> MockInfo {
        return MockInfo(
            mockedType: MockedType.self
        )
    }
}
