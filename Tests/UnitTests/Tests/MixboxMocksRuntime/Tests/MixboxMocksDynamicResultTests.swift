import MixboxMocksRuntime
import XCTest
import MixboxFoundation
import MixboxTestsFoundation

final class MixboxMocksDynamicResultTests: BaseMixboxMocksRuntimeTests {
    let mock = MockMocksTestsFixtureSimpleProtocol()
    let dynamicCallable = MockDynamicCallable()
    var factory: MockManagerFactory {
        ConfiguredMockManagerFactory(
            testFailureRecorder: dependencies.resolve(),
            waiter: dependencies.resolve(),
            defaultTimeout: 0,
            defaultPollingInterval: 0,
            dynamicCallable: dynamicCallable
        )
    }
    
    override var reuseState: Bool {
        false
    }
    
    override func precondition() {
        super.precondition()
        
        mock.setMockManager(factory.mockManager())
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
        stubDynamicCallable(argument: any())
            .thenReturn(.returned(123456789))
        
        XCTAssertEqual(
            mock.function(int: 1),
            123456789
        )
    }
    
    func test___mock___doesnt_use_dynamicCallable_result___if_dynamicCallable_is_set_to_return_canNotProvideResult() {
        // TODO: Error is not not used anywhere. Use it in error description.
        stubDynamicCallable(argument: 1)
            .thenReturn(.canNotProvideResult(ErrorString("error")))
        
        assertFails {
            _ = mock.function(int: 1)
        }
    }
    
    func test___mock___doesnt_use_dynamicCallable_result___if_default_implementation_is_set() {
        stubDynamicCallable(argument: any())
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
    
    func test___mock___doesnt_use_dynamicCallable_result___if_mock_is_stubbed() {
        stubDynamicCallable(argument: any())
            .thenReturn(.returned(123456789))
        
        mock.stub().function(int: 1).thenReturn(987654321)
        
        // Stubs have higher priority than dynamic implementation
        XCTAssertEqual(
            mock.function(int: 1),
            987654321
        )
        
        // This only works if stubs exactly match arguments
        XCTAssertEqual(
            mock.function(int: 2),
            123456789
        )
    }
    
    // MARK: - Private
    
    private func stubDynamicCallable<T: MixboxMocksRuntime.Matcher>(
        argument: T)
        -> StubbingFunctionBuilder<
            (RecordedCallArguments, Int.Type),
            DynamicCallableResult<Int>
        >
        where
        T.MatchingType == Int
    {
        return dynamicCallable
            .stub()
            .call(
                recordedCallArguments: matches { [uninterceptableErrorTracker] in
                    if let value = $0.arguments.mb_only?.asTypedRegular(type: Int.self) {
                        return argument.valueIsMatching(value)
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
