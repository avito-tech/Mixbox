import MixboxMocksRuntime
import XCTest
import MixboxFoundation
import MixboxTestsFoundation
import MixboxGenerators

final class AnyGeneratorDynamicCallableTests: BaseMixboxMocksRuntimeTests {
    func test___call___calls_generator() {
        checkGenerator(
            isCalled: true,
            forArguments: [],
            returnValueType: Void.self
        )
    }
    
    func test___call___doesnt_call_generator___if_arguments_dont_contain_closures_returning_void() {
        checkGenerator(
            isCalled: false,
            forArguments: [.escapingClosure(value: {}, argumentTypes: [], returnValueType: Int.self)],
            returnValueType: Void.self
        )
        
        checkGenerator(
            isCalled: false,
            forArguments: [.optionalEscapingClosure(value: {}, argumentTypes: [], returnValueType: Int.self)],
            returnValueType: Void.self
        )
    }
    
    func test___call___doesnt_call_generator___if_arguments_contains_closures_returning_void() {
        checkGenerator(
            isCalled: false,
            forArguments: [.escapingClosure(value: {}, argumentTypes: [], returnValueType: Void.self)],
            returnValueType: Void.self
        )
        
        checkGenerator(
            isCalled: false,
            forArguments: [.optionalEscapingClosure(value: {}, argumentTypes: [], returnValueType: Void.self)],
            returnValueType: Void.self
        )
    }
    
    private func checkGenerator<T>(
        isCalled: Bool,
        forArguments arguments: [RecordedCallArgument],
        returnValueType: T.Type)
    {
        let anyGenerator = MockAnyGenerator()
        let dynamicCallable = AnyGeneratorDynamicCallable(
            anyGenerator: anyGenerator
        )
        
        // Generator is not stubbed, so if it is called, test failure will occur. Suppress test failures:
        _ = gatherFailures {
            _ = dynamicCallable.call(
                recordedCallArguments: RecordedCallArguments(arguments: arguments),
                returnValueType: returnValueType
            )
        }
        
        anyGenerator
            .verify()
            .generate()
            .returning(returnValueType)
            .isCalled(times: .exactly(isCalled ? 1 : 0), timeout: 0)
    }
}
