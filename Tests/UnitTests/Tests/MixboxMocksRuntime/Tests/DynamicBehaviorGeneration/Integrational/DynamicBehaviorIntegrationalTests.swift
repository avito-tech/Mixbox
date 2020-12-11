import MixboxMocksRuntime
import MixboxGenerators
import XCTest

final class DynamicBehaviorIntegrationalTests: TestCase {
    let mock = MockDynamicBehaviorIntegrationalTestsProtocol()
    
    override var reuseState: Bool {
        false
    }
    
    override func precondition() {
        super.precondition()
        
        mocks.register(type: Generator<Int>.self) { _ in
            ConstantGenerator(42)
        }
    }
    
    func test___intFunction() {
        XCTAssertEqual(
            42,
            mock.intFunction()
        )
    }
    
    func test___asyncVoidFunction() {
        var asyncResult: Int = 0
        
        mock.asyncVoidFunction(completion: {
            asyncResult = $0
        })
        
        XCTAssertEqual(
            42,
            asyncResult
        )
    }
    
    func test___asyncNonVoidFunction() {
        var asyncResult: Int = 0
        
        XCTAssertEqual(
            42,
            mock.asyncNonVoidFunction(completion: {
                asyncResult = $0
            })
        )
        
        XCTAssertEqual(
            42,
            asyncResult
        )
    }
    
    func test___functionWithClosure() {
        var asyncResult: Int = 0
        
        XCTAssertEqual(
            42,
            mock.functionWithClosure(closure: {
                asyncResult = $0
            })
        )
        
        XCTAssertEqual(
            0,
            asyncResult
        )
    }
}
