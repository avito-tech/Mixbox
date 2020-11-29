import MixboxMocksRuntime
import XCTest
import MixboxFoundation
import MixboxTestsFoundation

// Tests that `RecordedCallArguments` are made correctly by code generation.
// - `RecordedCallArguments` is used in calling - they are passed to `DynamicCallable`
// - Also they are used n verification.
//
// TODO: Add info (to RecordedCall) about:
//
// - function signature, especially return type
//
// - `inout` modifiers
//
//   It is a worthy info for `DynamicCallable` as inout arguments are expected to be modified.
//
// - whether it is property
//
//   For example, if asyncronous function is dynamically generated, it might call `completion` closure,
//   but if it's property (closure is being set) then we probably shouldn't call the closure.
//
final class MixboxMocksArgumentGenerationTests: BaseMixboxMocksRuntimeTests {
    let mock = MockMocksTestsFixtureProtocol()
    let recordedCallsHolder = RecordedCallsHolderImpl()
    
    override var reuseState: Bool {
        false
    }
    
    override func precondition() {
        super.precondition()
        
        mock.setMockManager(
            mockManager(recordedCallsHolder: recordedCallsHolder)
        )
    }
    
    func test___code_generation___generate_correct_RecordedCallArguments__for_function_with_no_arguments() {
        check___code_generation___generate_correct_RecordedCallArguments(
            function: { $0.function() as Void },
            verifyRecordedCallArguments: { arguments in
                XCTAssertEqual(
                    arguments.count,
                    0
                )
            }
        )
    }
    
    func test___code_generation___generate_correct_RecordedCallArguments__for_function_with_regular_arguments() {
        check___code_generation___generate_correct_RecordedCallArguments(
            function: { $0.function(argument0: 100, argument1: 200) },
            verifyRecordedCallArguments: { arguments in
                let (argument0, argument1) = arguments.onlyOrFail()
                
                XCTAssertEqual(
                    argument0.asTypedRegular(),
                    100
                )
                XCTAssertEqual(
                    argument1.asTypedRegular(),
                    200
                )
            }
        )
    }
    
    func test___code_generation___generate_correct_RecordedCallArguments__for_function_with_non_escaping_closure_arguments() {
        check___code_generation___generate_correct_RecordedCallArguments(
            function: { $0.function(closure: {}) },
            verifyRecordedCallArguments: { arguments in
                let argument = arguments.onlyOneOrFail
                
                XCTAssert(
                    argument.asNonEscapingClosureType() == (() -> ()).self
                )
            }
        )
    }
    
    func test___code_generation___generate_correct_RecordedCallArguments__for_function_with_escaping_closure_arguments() {
        check___code_generation___generate_correct_RecordedCallArguments(
            function: { $0.function(escapingClosure: {}) },
            verifyRecordedCallArguments: { arguments in
                let argument = arguments.onlyOneOrFail
                
                if case let .escapingClosure(_, argumentTypes, returnValueType) = argument {
                    XCTAssertEqual(argumentTypes.count, 0)
                    XCTAssert(returnValueType == Void.self)
                } else {
                    XCTFail("Wrong argument type: \(argument)")
                }
            }
        )
    }
    
    func test___code_generation___generate_correct_RecordedCallArguments__for_function_with_optional_escaping_closure_arguments() {
        check___code_generation___generate_correct_RecordedCallArguments(
            function: {
                $0.function(optionalClosure: { _, _, _ in 1 })
            },
            verifyRecordedCallArguments: { arguments in
                let argument = arguments.onlyOneOrFail
                
                if case let .optionalEscapingClosure(value, argumentTypes, returnValueType) = argument {
                    XCTAssertNotNil(value)
                    
                    let (type0, type1, type2) = argumentTypes.onlyOrFail()
                    
                    XCTAssert(type0 == Int.self)
                    XCTAssert(type1 == String.self)
                    XCTAssert(type2 == (() throws -> ()).self)
                    
                    XCTAssert(returnValueType == Int.self)
                } else {
                    XCTFail("Wrong argument type: \(argument)")
                }
            }
        )
    }
    
    // MARK: - Private
    
    private func check___code_generation___generate_correct_RecordedCallArguments(
        function: (MocksTestsFixtureProtocol) -> (),
        verifyRecordedCallArguments: @escaping ([RecordedCallArgument]) -> ())
    {
        check___code_generation___generate_correct_RecordedCallArguments(
            function: function,
            verifyRecordedCall: { call in
                verifyRecordedCallArguments(call.arguments.arguments)
            }
        )
    }
    
    private func check___code_generation___generate_correct_RecordedCallArguments(
        function: (MocksTestsFixtureProtocol) -> (),
        verifyRecordedCall: @escaping (RecordedCall) -> ())
    {
        // This is expected to fail since nothing is stubbed
        assertFails {
            function(mock)
        }
        
        // Only 1 call is expected
        verifyRecordedCall(recordedCallsHolder.recordedCalls.onlyOrFail())
    }
    
    // Generates mock manager with everything mocked except for `RecordedCallsHolder`.
    // `RecordedCallsHolder` will be used in tests.
    private func mockManager(
        recordedCallsHolder: RecordedCallsHolder)
        -> MockManager
    {
        // Generate just any implementation for unrelated entities
        let mockRegisterer = dependencies.resolve() as MockRegisterer
        
        return MockManagerImpl(
            stubbing: mockRegisterer.register(MockMockManagerStubbing()),
            calling: MockManagerCallingImpl(
                testFailureRecorder: mockRegisterer.register(MockTestFailureRecorder()),
                recordedCallsHolder: recordedCallsHolder,
                stubsProvider: mockRegisterer.register(MockStubsProvider()),
                dynamicCallable: CanNotProvideResultDynamicCallable(
                    error: ErrorString("It is irrelevant for this test")
                )
            ),
            verification: mockRegisterer.register(MockMockManagerVerification()),
            stateTransferring: mockRegisterer.register(MockMockManagerStateTransferring())
        )
    }
}
