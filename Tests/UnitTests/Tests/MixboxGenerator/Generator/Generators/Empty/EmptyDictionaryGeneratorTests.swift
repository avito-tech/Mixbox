import MixboxGenerator
import XCTest

final class EmptyDictionaryGeneratorTests: TestCase {
    func test___generate___generates_empty_array() {
        let generator = EmptyDictionaryGenerator<Int, Int>()
        XCTAssertEqual(try generator.generate(), [:])
    }
}
