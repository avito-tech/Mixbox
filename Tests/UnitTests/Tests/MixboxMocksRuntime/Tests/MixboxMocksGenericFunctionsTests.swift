import MixboxMocksRuntime
import XCTest
import MixboxFoundation

final class MixboxMocksGenericFunctionsTests: BaseMixboxMocksRuntimeTests {
    let mock = MockMocksTestsFixtureProtocol()
    
    func test___calling_and_verifcation___fail___if_generic_was_stubbed_with_same_type() {
        mock
            .stub()
            .genericFunctionWithSameReturnValue(generic: any(type: Int.self))
            .thenReturn(100)
        
        _ = mock.genericFunctionWithSameReturnValue(generic: 100) as Int
    
        mock
            .verify()
            .genericFunctionWithSameReturnValue(generic: any(type: Int.self))
            .isCalledOnlyOnce(timeout: 0)
    }
    
    func test___calling_and_verifcation___pass___if_generic_was_stubbed_with_different_type() {
        mock
            .stub()
            .genericFunctionWithSameReturnValue(generic: any(type: Int.self))
            .thenReturn(100)
        
        // Use String instead of Int (function was stubbed with Int)
        
        assertFails {
            _ = mock.genericFunctionWithSameReturnValue(generic: "100") as String
        }
        
        // Use Int instead of String (function was called with String)
        assertFails {
            mock
                .verify()
                .genericFunctionWithSameReturnValue(generic: any(type: Int.self))
                .isCalledOnlyOnce(timeout: 0)
        }
    }
    
    // TODO: Fix test. Currently return value is not checked.
    func disabled_test___calling_and_verifcation___fails___if_generic_was_stubbed_with_different_return_value() {
        mock
            .stub()
            .genericFunctionWithDifferentReturnValue(generic: any(type: String.self))
            .thenReturn(100)
        
        // Self-check
        _ = mock.genericFunctionWithDifferentReturnValue(generic: "100") as Int
        
        // Self-check
        mock
            .verify()
            .genericFunctionWithDifferentReturnValue(generic: any(type: String.self))
            .returning(Int.self)
            .isCalledOnlyOnce(timeout: 0)
        
        assertFails {
            mock
                .verify()
                .genericFunctionWithDifferentReturnValue(generic: any(type: String.self))
                .returning(String.self)
                .isCalledOnlyOnce(timeout: 0)
        }
        
        assertFails {
            mock
                .verify()
                .genericFunctionWithDifferentReturnValue(generic: any(type: Int.self))
                .returning(Int.self)
                .isCalledOnlyOnce(timeout: 0)
        }
        
        assertFails {
            mock
                .verify()
                .genericFunctionWithDifferentReturnValue(generic: any(type: String.self))
                .returning(Int.self)
                .isCalledOnlyOnce(timeout: 0)
        }
        
        assertFails {
            _ = mock.genericFunctionWithDifferentReturnValue(generic: 100) as String
        }
        
        assertFails {
            _ = mock.genericFunctionWithDifferentReturnValue(generic: 100) as Int
        }
        
        assertFails {
            _ = mock.genericFunctionWithDifferentReturnValue(generic: "100") as String
        }
    }
}
