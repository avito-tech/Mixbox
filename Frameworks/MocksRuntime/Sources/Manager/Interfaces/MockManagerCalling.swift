import MixboxFoundation
import MixboxGenerators

// TODO: It can be better to use array of arguments instead of a tuple.
//
// Pros:
// - Easy to work with, introspect, for example
// - Non-escaping closures can be just replaced with special class, instead of being faked out
//   faking out closures can lead to misinterpreting their values, possible bugs in the future,
//   also it's a good pattern when code expresses what's actually haappening instead of fake data.
//
// Cons:
// - Some overhead is probable, but that's not certain
// - Automatic typecheck, e.g. no neet to check arguments count and type of each argument.
//
public protocol MockManagerCalling {
    func call<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        -> ReturnValue
        
    func callThrows<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        throws
        -> ReturnValue
        
    func callRethrows<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        rethrows
        -> ReturnValue
}
