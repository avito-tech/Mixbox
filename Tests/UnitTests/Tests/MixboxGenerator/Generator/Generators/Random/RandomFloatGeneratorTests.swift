import MixboxGenerators
import XCTest

final class RandomFloatGeneratorTests: TestCase {
    func test___generate___works_properly() {
        assert(
            randomNumber: 0,
            closedRange: 0...100,
            leadsTo: 0
        )
        assert(
            randomNumber: UInt64.max / 10 * 3,
            closedRange: 0...100,
            leadsTo: 30
        )
        assert(
            randomNumber: UInt64.max,
            closedRange: 0...100,
            leadsTo: 100
        )
    }
    
    func test___generate___works_properly___for_zero_range() {
        assert(
            randomNumber: 0,
            closedRange: 0...0,
            leadsTo: 0
        )
        assert(
            randomNumber: UInt64.max,
            closedRange: 0...0,
            leadsTo: 0
        )
    }
    
    private func assert(randomNumber: UInt64, closedRange: ClosedRange<Double>, leadsTo expectedResult: Double) {
        let generator = RandomFloatGenerator<Double>(
            randomNumberProvider: ConstantRandomNumberProvider(randomNumber),
            closedRange: closedRange
        )
        XCTAssertEqual(try generator.generate(), expectedResult)
    }
}
