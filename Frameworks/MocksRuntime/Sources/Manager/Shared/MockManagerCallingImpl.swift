import MixboxFoundation
import MixboxTestsFoundation
import MixboxGenerators

public final class MockManagerCallingImpl: MockManagerCalling {
    private let testFailureRecorder: TestFailureRecorder
    private let recordedCallsHolder: RecordedCallsHolder
    private let stubsProvider: StubsProvider
    private let dynamicCallableFactory: DynamicCallableFactory
    
    private enum ThrowingType {
        case none
        case `throws`
        case `rethrows`
    }
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        recordedCallsHolder: RecordedCallsHolder,
        stubsProvider: StubsProvider,
        dynamicCallableFactory: DynamicCallableFactory)
    {
        self.testFailureRecorder = testFailureRecorder
        self.recordedCallsHolder = recordedCallsHolder
        self.stubsProvider = stubsProvider
        self.dynamicCallableFactory = dynamicCallableFactory
    }
    
    public func call<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        -> ReturnValue
    {
        return callAny(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            tupledArguments: tupledArguments,
            nonEscapingCallArguments: nonEscapingCallArguments,
            generatorSpecializations: generatorSpecializations,
            throwingType: .none
        )
    }
    
    public func callThrows<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        throws
        -> ReturnValue
    {
        return try callAny(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            tupledArguments: tupledArguments,
            nonEscapingCallArguments: nonEscapingCallArguments,
            generatorSpecializations: generatorSpecializations,
            throwingType: .throws
        )
    }
        
    public func callRethrows<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        rethrows
        -> ReturnValue
    {
        return try callAny(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            tupledArguments: tupledArguments,
            nonEscapingCallArguments: nonEscapingCallArguments,
            generatorSpecializations: generatorSpecializations,
            throwingType: .rethrows
        )
    }
    
    // TODO: Support stubbing of throwing/rethrowing functions
    // TODO: Split
    // swiftlint:disable:next function_body_length
    private func callAny<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization],
        throwingType: ThrowingType)
        rethrows
        -> ReturnValue
    {
        let recordedCallArguments = self.recordedCallArguments(
            nonEscapingCallArguments: nonEscapingCallArguments
        )
        
        let recordedCall = RecordedCall(
            functionIdentifier: functionIdentifier,
            arguments: recordedCallArguments
        )
        
        recordedCallsHolder.recordedCalls.append(recordedCall)

        let returnValueOrNil: ReturnValue?
        do {
            returnValueOrNil = try stubsProvider.stubs[functionIdentifier].flatMap { stubs in
                try stubs
                    .last { $0.matches(recordedCallArguments: recordedCallArguments) }
                    .map { try $0.value(tupledArguments: tupledArguments) }
            }
        } catch {
            fail(error)
        }
            
        if let returnValue = returnValueOrNil {
            return returnValue
        } else if var defaultImplementation = defaultImplementation {
            return try defaultImplementationClosure(&defaultImplementation, tupledArguments)
        } else {
            let dynamicCallable = dynamicCallableFactory.dynamicCallable(
                generatorSpecializations: generatorSpecializations
            )
            
            let result = dynamicCallable.call(
                nonEscapingCallArguments: nonEscapingCallArguments,
                returnValueType: ReturnValue.self
            )
            
            let messageAboutUnstubbedCall = """
            Call to function \(functionIdentifier) with args \(tupledArguments) and return \
            value of type \(ReturnValue.self) was not stubbed
            """
            
            switch result {
            case let .threw(error):
                /// Note: program may crash if you throw error from rethrowng function,
                /// and errors aren't handled (e.g. source closure isn't throwing).
                /// I spent 1 hour trying to find how to checck if errors are handled.
                /// I came to nothing.
                ///
                /// Here are my findings:
                ///
                /// - Swift wraps every closure to throwing closure in a rethrowing function:
                ///
                ///     ```
                ///     import Foundation
                ///     class E: Error {}
                ///
                ///     func x(any: Any, closure: @escaping () throws -> ()) rethrows {
                ///         withUnsafePointer(to: any) { ptr in
                ///             print(ptr)
                ///         }
                ///         withUnsafePointer(to: closure) { ptr in
                ///             print(ptr)
                ///         }
                ///         debugPrint("0", (any as? Any) as? (() throws -> ()))
                ///         debugPrint("1", (any as? Any) as? () -> ())
                ///         debugPrint("2", (closure as? Any) as? (() throws -> ()))
                ///         debugPrint("3", (closure as? Any) as? () -> ())
                ///
                ///         try closure()
                ///     }
                ///
                ///     print("A")
                ///     do {
                ///         let closure: () throws -> () = {
                ///             print("from A")
                ///             throw E()
                ///         }
                ///         try x(any: closure, closure: closure)
                ///     } catch {}
                ///
                ///     do {
                ///         let closure: () -> () = { print("from B") }
                ///         print("B")
                ///         x(any: closure, closure: closure)
                ///     }
                ///     ```
                ///
                ///     Results:
                ///
                ///     ```
                ///     A
                ///     0x00007ffeeb9276c8
                ///     0x00007ffeeb9275f0
                ///     "0" Optional((Function))
                ///     "1" nil
                ///     "2" Optional((Function))
                ///     "3" nil
                ///     from A
                ///     B
                ///     0x00007ffeeb9276c8
                ///     0x00007ffeeb9275f0
                ///     "0" Optional((Function))
                ///     "1" Optional((Function))
                ///     "2" Optional((Function))
                ///     "3" nil
                ///     from B
                ///     ```
                ///
                /// - I didn't find where this wrapping occurs or how to detect it.
                ///
                /// - If not wrapping, casting would be a way to determine if function is throwing:
                ///
                ///     https://github.com/apple/swift/blob/fd820f53e6458223c578b86b217989371f76f300/stdlib/public/runtime/Casting.cpp#L1858
                ///
                
                switch throwingType {
                case .none:
                    fail(
                        """
                        \(messageAboutUnstubbedCall), dynamic behavior (`DynamicCallable`) resulted in \
                        throwing error \(error), which is a bug in making dynamic behavior, because
                        function `\(functionIdentifier)` is not throwing.
                        """
                    )
                case .throws:
                    // It is possible to throw from rethrowing function:
                    // https://forums.swift.org/t/rethrows-issue/7339/2
                    let localThrowingClosure: () throws -> () = {
                        throw error
                    }
                    try withoutActuallyEscaping(localThrowingClosure) { closure in
                        try closure()
                    }
                    
                    fail(
                        """
                        \(messageAboutUnstubbedCall), dynamic behavior resulted in throwing error and error \
                        was thrown, however, because of unknown reason it didn't stop the execution of
                        current function (\(Self.self).\(#function)). This is an internal error.
                        """
                    )
                case .rethrows:
                    fail(
                        """
                        \(messageAboutUnstubbedCall), dynamic behavior (`DynamicCallable`) resulted in \
                        throwing error \(error), however function `\(functionIdentifier)` is rethrowing and \
                        currently throwing errors from rethrowing functions is not supported, because \
                        we can't be sure if thrown errors are handled by caller and if we can't check it \
                        there is a risk of a crash.
                        """
                    )
                }
            case let .returned(returnValue):
                return returnValue
            case let .canNotProvideResult(error):
                fail(
                    """
                    \(messageAboutUnstubbedCall), dynamic behavior also was not created due to: \(error)
                    """
                )
            }
        }
    }
    
    private func recordedCallArguments(
        nonEscapingCallArguments: NonEscapingCallArguments)
        -> RecordedCallArguments
    {
        return RecordedCallArguments(
            arguments: nonEscapingCallArguments.arguments.map { argument in
                RecordedCallArgument(
                    name: argument.name,
                    type: argument.type,
                    value: recordedCallArgumentValue(
                        nonEscapingCallArgumentValue: argument.value
                    )
                )
            }
        )
    }
    
    private func recordedCallArgumentValue(
        nonEscapingCallArgumentValue: NonEscapingCallArgumentValue)
        -> RecordedCallArgumentValue
    {
        switch nonEscapingCallArgumentValue {
        case let .escapingClosure(nested):
            return .escapingClosure(nested)
        case .nonEscapingClosure:
            return .nonEscapingClosure
        case let .optionalEscapingClosure(nested):
            return .optionalEscapingClosure(nested)
        case let .regular(nested):
            return .regular(nested)
        }
    }
    
    private func fail(_ string: String) -> Never {
        fail(ErrorString(string))
    }

    private func fail(_ error: Error) -> Never {
        testFailureRecorder.recordUnavoidableFailure(description: "\(error)")
    }
}
