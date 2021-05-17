import MixboxMocksRuntime
import XCTest
import MixboxFoundation
import MixboxTestsFoundation

final class MixboxMocksDynamicResultTests: BaseMixboxMocksRuntimeTests {
    let mock = MockMocksTestsFixtureSimpleProtocol()
    let dynamicCallable = MockDynamicCallable()
    let dynamicCallableFactory = MockDynamicCallableFactory()
    var factory: MockManagerFactory {
        ConfiguredMockManagerFactory(
            testFailureRecorder: dependencies.resolve(),
            waiter: dependencies.resolve(),
            defaultTimeout: 0,
            defaultPollingInterval: 0,
            dynamicCallableFactory: dynamicCallableFactory
        )
    }
    
    override var reuseState: Bool {
        false
    }
    
    override func precondition() {
        super.precondition()
        
        mock.setMockManager(factory.mockManager())
        
        dynamicCallableFactory
            .stub()
            .dynamicCallable()
            .thenReturn(dynamicCallable)
    }
    
    // Self-check for this test. Note that ideally you should check every value of
    // argument that is used in this test.
    func test___mock___fails_to_call_functions___initially() {
        let argumentValuesUsedInThisTest = [1, 2]
        
        argumentValuesUsedInThisTest.forEach { value in
            assertFails {
                _ = mock.function(int: value)
            }
        }
    }
    
    func test___mock___uses_dynamicCallable_result___if_dynamicCallable_is_set_to_return_value() {
        stubDynamicCallable()
            .thenReturn(.returned(123456789))
        
        XCTAssertEqual(
            mock.function(int: 1),
            123456789
        )
    }
    
    func test___mock___doesnt_use_dynamicCallable_result___if_dynamicCallable_is_set_to_return_canNotProvideResult() {
        // TODO: Error is not not used anywhere. Use it in error description.
        stubDynamicCallable(argument: equals(1))
            .thenReturn(.canNotProvideResult(ErrorString("error")))
        
        assertFails {
            _ = mock.function(int: 1)
        }
    }
    
    func test___mock___doesnt_use_dynamicCallable_result___if_default_implementation_is_set() {
        stubDynamicCallable()
            .thenReturn(.returned(123456789))
        
        class DefaultImplementation: MocksTestsFixtureSimpleProtocol {
            func function(int: Int) -> Int {
                return 987654321
            }
        }
        
        mock.setDefaultImplementation(DefaultImplementation())
        
        // Default implemetation has higher priority than dynamic implementation
        XCTAssertEqual(
            mock.function(int: 1),
            987654321
        )
    }
    
    func test___mock___uses_dynamicCallable_result___if_mock_is_stubbed_but_arguments_dont_match_stub() {
        stubDynamicCallable()
            .thenReturn(.returned(123456789))
        
        mock.stub().function(int: equals(1)).thenReturn(987654321)
        
        // There is stub for arguments equals to 1, not for 2 => use dynamic callable
        XCTAssertEqual(
            mock.function(int: 2),
            123456789
        )
    }
    
    func test___mock___doesnt_use_dynamicCallable_result___if_mock_is_stubbed_and_arguments_match_stab() {
        stubDynamicCallable()
            .thenReturn(.returned(123456789))
        
        mock.stub().function(int: equals(1)).thenReturn(987654321)
        
        // Stubs have higher priority than dynamic implementation
        XCTAssertEqual(
            mock.function(int: 1),
            987654321
        )
    }
    
    // MARK: - Private
    
    private func stubDynamicCallable(
        argument: Matcher<Int> = any())
        -> StubbingFunctionBuilder<
            (NonEscapingCallArguments, Int.Type),
            DynamicCallableResult<Int>
        >
    {
        return dynamicCallable
            .stub()
            .call(
                nonEscapingCallArguments: matches { [uninterceptableErrorTracker] in
                    if let value = $0.arguments.mb_only?.value.asRegular()?.value as? Int {
                        return argument.match(value: value).matched
                    } else {
                        uninterceptableErrorTracker.track(
                            error: ErrorString("Unexpected call to DynamicCallable")
                        )
                        return false
                    }
                },
                returnValueType: any()
            )
    }
}
