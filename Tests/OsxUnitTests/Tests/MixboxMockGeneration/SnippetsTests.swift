import MixboxMocksGeneration
import XCTest

final class SnippetsTests: XCTestCase {
    func test() {
        XCTAssertEqual(
            Snippets.labeledArgumentForFunctionSignature(label: "a", name: "b"),
            "a b"
        )
        
        XCTAssertEqual(
            Snippets.labeledArgumentForFunctionSignature(label: "x", name: "x"),
            "x"
        )
        
        XCTAssertEqual(
            Snippets.labeledArgumentForFunctionSignature(label: nil, name: "b"),
            "_ b"
        )
    }
}
