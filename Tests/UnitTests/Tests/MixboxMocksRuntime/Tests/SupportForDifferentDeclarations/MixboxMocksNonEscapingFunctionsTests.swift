import MixboxMocksRuntime
import MixboxTestsFoundation
import XCTest

// Test covers this bug:
//
// 1. `call()` stored every paremeter in array, to check them later in `verify()`
// 2. This made closure escape
// 3. This error occured, leading to crash: `closure argument was escaped in withoutActuallyEscaping block`
//
// This code produces the error (link to code that checks reference count of closure):
// https://github.com/apple/swift/blob/aa3e5904f8ba8bf9ae06d96946774d171074f6e5/stdlib/public/runtime/SwiftObject.mm#L1400
//
// Solution was: not to store non-escaping closures.
//
final class MixboxMocksNonEscapingFunctionsTests: BaseMixboxMocksRuntimeTests {
    let mock = MockMocksTestsFixtureProtocol()
    
    func test() {
        let expectedTimeClosureWasCalled = 42
        
        mock
            .stub()
            .function(closure: any())
            .thenInvoke { closure in
                (0..<expectedTimeClosureWasCalled).forEach { _ in
                    closure()
                }
            }
        
        var actualTimesClosureWasCalled = 0
        
        mock.function(
            closure: {
                actualTimesClosureWasCalled += 1
            }
        )
        
        XCTAssertEqual(
            actualTimesClosureWasCalled,
            expectedTimeClosureWasCalled
        )
        
        mock
            .verify()
            .function(closure: any())
            .isCalledOnlyOnce()
        
        mock
            .verify()
            .function(autoclosure: any())
            .isNotCalled()
    }
}
