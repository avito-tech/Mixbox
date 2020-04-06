import MixboxGenerator
import XCTest

final class RandomDictionaryGeneratorTests: TestCase {
    func test() {
        let generator = RandomDictionaryGenerator<Int, Int>(
            anyGenerator: SequenceAnyGenerator([1, 2, 3, 4, 5, 6, 7]),
            lengthGenerator: ConstantGenerator(3)
        )
        XCTAssertEqual(try generator.generate(), [1: 2, 3: 4, 5: 6])
    }
}
