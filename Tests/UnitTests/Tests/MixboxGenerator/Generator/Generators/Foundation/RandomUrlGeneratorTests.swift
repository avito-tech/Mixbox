import MixboxGenerators
import XCTest

final class RandomUrlGeneratorTests: TestCase {
    func test() {
        let generator = RandomUrlGenerator(randomNumberProvider: ConstantRandomNumberProvider(0))
        
        XCTAssertEqual(try generator.generate(), URL(string: "aaaaaaaaaaaaaaaaaaaa"))
    }
}
