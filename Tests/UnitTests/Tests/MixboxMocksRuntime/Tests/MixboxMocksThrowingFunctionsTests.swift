import MixboxMocksRuntime
import XCTest
import MixboxFoundation

final class MixboxMocksThrowingFunctionsTests: BaseMixboxMocksRuntimeTests {
    let mock = MockMocksTestsFixtureProtocol()
    
    func test___calling_throwing_function___fails_test___if_not_stubbed() {
        assertFails {
            // Should fail test instead of throwing
            assertDoesntThrow {
                _ = try mock.throwingFunction()
            }
        }
    }
    
    func test___calling_throwing_function___uses_stub___if_stubbed_with_non_throwing_result() {
        mock.stub().throwingFunction().thenReturn(42)
        
        assertDoesntThrow {
            XCTAssertEqual(
                try mock.throwingFunction(),
                42
            )
        }
    }
    
    func disabled_test___calling_throwing_function___uses_stub___if_stubbed_with_throwing_result() {
        // TODO: Support stubbing
    }
    
    func test___calling_rethrowing_function___fails_test___if_not_stubbed_and_called_with_nonthrowing_closure() {
        assertFails {
            // Should fail test instead of throwing
            assertDoesntThrow {
                _ = mock.rethrowingFunction { 42 }
            }
        }
    }
    
    func test___calling_rethrowing_function___fails_test___if_not_stubbed_and_called_with_throwing_closure() {
        assertFails {
            // Should fail test instead of throwing
            assertDoesntThrow {
                _ = try mock.rethrowingFunction {
                    throw ErrorString("42")
                }
            }
        }
    }
    
    // TODO: Test stubbing of rethrowing functions
}
