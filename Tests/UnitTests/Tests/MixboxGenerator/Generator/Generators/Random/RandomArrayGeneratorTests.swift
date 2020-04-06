import MixboxGenerator
import XCTest

final class RandomArrayGeneratorTests: TestCase {
    func test() {
        let generator = RandomArrayGenerator<Int>(
            anyGenerator: SequenceAnyGenerator([1, 2, 3, 4]),
            lengthGenerator: ConstantGenerator(3)
        )
        XCTAssertEqual(try generator.generate(), [1, 2, 3])
    }
}
