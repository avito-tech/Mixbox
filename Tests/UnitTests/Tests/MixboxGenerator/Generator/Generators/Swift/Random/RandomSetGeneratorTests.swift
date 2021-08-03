import MixboxGenerators
import XCTest

final class RandomSetGeneratorTests: TestCase {
    func test___generate___works_correctly___in_a_positive_case() {
        let generator = RandomSetGenerator<Int>(
            anyGenerator: SequenceAnyGenerator([1, 2, 3, 4]),
            lengthGenerator: ConstantGenerator(3)
        )
        XCTAssertEqual(try generator.generate(), Set([1, 2, 3]))
    }
    
    func test___generate___tries_to_generate_unique_values_for_limited_number_of_attempts() {
        let generator = RandomSetGenerator<Int>(
            anyGenerator: SequenceAnyGenerator([1, 1, 1, 2, 2, 2, 3, 3, 3]),
            lengthGenerator: ConstantGenerator(3)
        )
        XCTAssertEqual(try generator.generate(), Set([1, 2]))
    }
}
