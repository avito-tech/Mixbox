import MixboxFoundation

public protocol MockManagerCalling {
    func call<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) -> ReturnValue,
        arguments: Arguments)
        -> ReturnValue
        
    func callThrows<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) throws -> ReturnValue,
        arguments: Arguments)
        throws
        -> ReturnValue
        
    func callRethrows<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) throws -> ReturnValue,
        arguments: Arguments)
        rethrows
        -> ReturnValue
}
