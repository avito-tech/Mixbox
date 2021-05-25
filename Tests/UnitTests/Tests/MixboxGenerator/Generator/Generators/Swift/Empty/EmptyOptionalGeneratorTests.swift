import MixboxGenerators
import XCTest

final class EmptyOptionalGeneratorTests: TestCase {
    func test___generate___generates_empty_optional() {
        let generator = EmptyOptionalGenerator<Int>()
        XCTAssertNil(try generator.generate())
    }
}
