import MixboxMocksRuntime
import MixboxGenerators
import XCTest

final class EasyClosureStubbingIntegrationalTests: TestCase {
    let mock = MockEasyClosureStubbingIntegrationalTestsProtocol()
    
    override var reuseState: Bool {
        false
    }
    
    func test___void_function___can_be_stubbed_with_closure_call___with_name_variant_0() {
        mock
            .stub()
            .voidFunctionWithNameVariant0()
            .thenCall
            .completion(42)
        
        var asyncResult: Int = 0
        mock.voidFunctionWithNameVariant0(completion: {
            asyncResult = $0
        })
        
        XCTAssertEqual(
            42,
            asyncResult
        )
    }
    
    func test___void_function___can_be_stubbed_with_closure_call___with_name_variant_1() {
        mock
            .stub()
            .voidFunctionWithNameVariant1()
            .thenCall
            .closure(42)
        
        var asyncResult: Int = 0
        mock.voidFunctionWithNameVariant1(closure: {
            asyncResult = $0
        })
        
        XCTAssertEqual(
            42,
            asyncResult
        )
    }
    
    func test___function_with_void_arguments_in_closure___can_be_stubbed_with_closure_call() {
        mock
            .stub()
            .functionWithVoidArgumentsInClosure()
            .thenCall
            .closure()
        
        var asyncResult: Int = 0
        mock.functionWithVoidArgumentsInClosure(closure: {
            asyncResult = 42
        })
        
        XCTAssertEqual(
            42,
            asyncResult
        )
    }
    
    func test___non_void_function___can_not_be_stubbed_with_closure_call() {
        XCTAssert(
            type(of: mock.stub().nonVoidFunction())
                == StubbingFunctionBuilder<((Int) -> ()), Int>.self
        )
    }
    
    func test___function_with_closures_with_same_names___can_not_be_stubbed_with_closure_call() {
        XCTAssert(
            type(of: mock.stub().functionWithClosuresWithSameNames(completion: any(), completion: any()))
                == StubbingFunctionBuilder<(() -> (), () -> ()), ()>.self
        )
    }
}
