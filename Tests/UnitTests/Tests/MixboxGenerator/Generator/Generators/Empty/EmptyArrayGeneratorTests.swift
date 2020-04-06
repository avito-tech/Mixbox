import MixboxGenerator
import XCTest

final class EmptyArrayGeneratorTests: TestCase {
    func test___generate___generates_empty_array() {
        let generator = EmptyArrayGenerator<Int>()
        XCTAssertEqual(try generator.generate(), [])
    }
}
