import MixboxFoundation

public protocol MockManagerProvider {
    func getMockManager() -> MockManager
}

// TODO: Replace with `setMockManagerFactory`? This will make it less likely to
// set same `mockManager` to multiple instances.
public protocol MockManagerSettable {
    @discardableResult
    func setMockManager(_ mockManager: MockManager) -> MixboxMocksRuntimeVoid
}

public protocol DefaultImplementationSettable {
    associatedtype MockedType
    
    // TODO: Should we allow resetting it (making argument optional)?
    @discardableResult
    func setDefaultImplementation(_ defaultImplementation: MockedType) -> MixboxMocksRuntimeVoid
}

// Note: don't add properties to protocols to avoid name collisions.
// Properties don't support overloading.
public protocol Mock: class, MockManagerProvider, MockManagerSettable, DefaultImplementationSettable {
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
