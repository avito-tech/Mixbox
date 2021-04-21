import SourceryRuntime
import MixboxMocksGeneration
import XCTest

final class TypeName_TypeInstanceExpression_Tests: XCTestCase {
    func test___typeInstanceExpression___simply_adds_self___for_simple_types() {
        check(
            type: "Int",
            expression: "Int.self"
        )
    }
    
    func test___typeInstanceExpression___simply_adds_self___to_optionals() {
        check(
            type: "Int?",
            expression: "Int?.self"
        )
    }
    
    func test___typeInstanceExpression___removes_bangs_from_implicitly_unwrapped_optionals() {
        // `Int!.self` is not a valid expression
        
        check(
            type: "Int!",
            expression: "Int.self"
        )
    }
    
    func test___typeInstanceExpression___replaces_empty_tuple_with_void() {
        // `().self` is not a valid expression
        
        check(
            type: "()",
            expression: "Void.self"
        )
    }
    
    func test___typeInstanceExpression___removes_unnecessary_parenthesis___for_simple_types() {
        check(
            type: "(Int)",
            expression: "Int.self"
        )
    }
    
    func test___typeInstanceExpression___adds_parenthesis___to_tuples() {
        check(
            type: "(Int, Int)",
            expression: "((Int, Int)).self"
        )
    }
    
    func test___typeInstanceExpression___adds_parenthesis___to_closures() {
        // `() -> ().self` is not a valid expression
        
        check(
            type: "() -> ()",
            expression: "(() -> ()).self"
        )
    }
    
    func test___typeInstanceExpression___removes_argument_labels___from_closures___0() {
        // `((_ x: Int) -> ()).self` is not a valid expression
        
        check(
            type: "(_ level1: (_ level2: Int) -> ()) -> ()",
            expression: "(((Int) -> ()) -> ()).self"
        )
    }
    
    func test___typeInstanceExpression___removes_argument_labels___from_closures___1() {
        // Test with mixed styles (it found a bug, the code didn't work for not first arguments)
        
        check(
            type: "(Int, _: Int, _ label: Int) -> ()",
            expression: "((Int, _: Int, Int) -> ()).self"
        )
    }
    
    func test___typeInstanceExpression___removes_argument_labels___from_closures___2() {
        // But `((_: Int) -> ()).self` or `((Int) -> ()).self` are valid.
        // There are no replaces made here (in terms of arguments).
        
        check(
            type: "(_: Int) -> ()",
            expression: "((_: Int) -> ()).self"
        )
    }
    
    private func check(
        type: String,
        expression: String,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        let typeName = TypeName(type)
        
        XCTAssertEqual(
            typeName.typeInstanceExpression,
            expression,
            file: file,
            line: line
        )
    }
}
