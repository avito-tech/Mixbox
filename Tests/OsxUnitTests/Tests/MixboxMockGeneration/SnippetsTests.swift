import MixboxMocksGeneration
import XCTest

final class SnippetsTests: XCTestCase {
    func test() {
        XCTAssertEqual(
            Snippets.labeledArgument(label: "a", name: "b"),
            "a b"
        )
        
        XCTAssertEqual(
            Snippets.labeledArgument(label: "x", name: "x"),
            "x"
        )
        
        XCTAssertEqual(
            Snippets.labeledArgument(label: nil, name: "b"),
            "_ b"
        )
    }
}
