import MixboxGenerators
import XCTest

final class RandomBoolGeneratorTests: TestCase {
    func test() {
        assert(randomNumber: 0, leadsTo: false)
        assert(randomNumber: 1, leadsTo: true)
        assert(randomNumber: 2, leadsTo: false)
        assert(randomNumber: 3, leadsTo: true)
    }
    
    private func assert(randomNumber: UInt64, leadsTo expectedResult: Bool) {
        let generator = RandomBoolGenerator(
            randomNumberProvider: ConstantRandomNumberProvider(randomNumber)
        )
        XCTAssertEqual(try generator.generate(), expectedResult)
    }
}
