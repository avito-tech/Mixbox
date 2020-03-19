import MixboxGenerator
import XCTest

final class GeneratorTests: TestCase {
    func test___generate___calls_generateFunction_passed_via_init() {
        let generator = Generator<Int> { 42 }
        XCTAssertEqual(try generator.generate(), 42)
    }
}
