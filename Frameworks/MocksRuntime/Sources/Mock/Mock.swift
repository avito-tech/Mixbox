import MixboxFoundation

public protocol MockManagerProvider {
    func getMockManager() -> MockManager
}

public protocol MockManagerSettable {
    func setMockManager(mockManager: MockManager)
}

// Note: don't add properties to protocols to avoid name collisions.
// Properties don't support overloading.
public protocol Mock: class, MockManagerProvider, MockManagerSettable {
    associatedtype StubbingBuilder: MixboxMocksRuntime.StubbingBuilder
    associatedtype VerificationBuilder: MixboxMocksRuntime.VerificationBuilder
}

extension Mock {
    public func verify(file: StaticString = #file, line: UInt = #line) -> VerificationBuilder {
        return VerificationBuilder(
            mockManager: getMockManager(),
            fileLine: FileLine(
                file: file,
                line: line
            )
        )
    }
    
    public func stub(file: StaticString = #file, line: UInt = #line) -> StubbingBuilder {
        return StubbingBuilder(
            mockManager: getMockManager(),
            fileLine: FileLine(
                file: file,
                line: line
            )
        )
    }
}
