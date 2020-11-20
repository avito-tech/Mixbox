import MixboxMocksGeneration
import XCTest

final class CodeGenerationUtilsTests: XCTestCase {
    func test() {
        XCTAssertEqual(
            CodeGenerationUtils.labeledArgument(label: "a", name: "b"),
            "a b"
        )
        
        XCTAssertEqual(
            CodeGenerationUtils.labeledArgument(label: "x", name: "x"),
            "x"
        )
        
        XCTAssertEqual(
            CodeGenerationUtils.labeledArgument(label: nil, name: "b"),
            "_ b"
        )
    }
}
