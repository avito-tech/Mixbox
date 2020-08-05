import MixboxGenerators
import XCTest

final class MersenneTwisterRandomNumberProviderTests: TestCase {
    func test___sequence_of_random_numbers___is_different_for_different_seeds() {
        let lhs = MersenneTwisterRandomNumberProvider(seed: 0)
        let rhs = MersenneTwisterRandomNumberProvider(seed: 1)
        
        for _ in 0..<100 {
            XCTAssertNotEqual(
                lhs.nextRandomNumber(),
                rhs.nextRandomNumber()
            )
        }
    }
    
    func test___sequence_of_random_numbers___is_same_for_same_seeds() {
        let lhs = MersenneTwisterRandomNumberProvider(seed: 0)
        let rhs = MersenneTwisterRandomNumberProvider(seed: 0)
        
        for _ in 0..<100 {
            XCTAssertEqual(
                lhs.nextRandomNumber(),
                rhs.nextRandomNumber()
            )
        }
    }
    
    // Note: if this test fails, you can check that generator generates good random numbers by enabling
    // `test___sequence_of_random_numbers___is_random_enough`, running it, then disabling it again.
    // When you fix the issue, just copy-paste numbers from assertion failure to this function.
    func test___sequence_of_random_numbers___matches_reference() {
        let provider = MersenneTwisterRandomNumberProvider(seed: 42)
        let actualSequence = (0..<20).map { _ in
            provider.nextRandomNumber()
        }
        let expectedSequence: [UInt64] = [
            13930160852258120406, 11788048577503494824, 13874630024467741450, 2513787319205155662,
            16662371453428439381, 1735254072534978428, 10598951352238613536, 6878563960102566144,
            5052085463162682550, 7199227068870524257, 228421809995595595, 9660662969780974662,
            12641024047231570392, 11756813601242511406, 15247151809474287309, 17445057953250372392,
            13894429094723042358, 8281039959893252210, 863363284242328609, 1191558566432429351
        ]
        XCTAssertEqual(
            actualSequence,
            expectedSequence
        )
    }
    
    // https://en.wikipedia.org/wiki/Diehard_tests
    //
    // This is a very stupid version of OPERM5 test.
    //
    // It takes 15 seconds on new macbook pro, so it is disabled.
    // There is `test___sequence_of_random_numbers___matches_reference` test with reference values.
    //
    func disabled_test___sequence_of_random_numbers___is_random_enough() {
        let provider = MersenneTwisterRandomNumberProvider(seed: 42)
        
        let totalCount = 1000000
        var orderings = Array(repeating: 0, count: 99999)
        
        for _ in 0..<totalCount {
            orderings[provider.randomOrderingOfFiveElements()] += 1
        }
        
        let permutations: Double = 120 // 5! = 120
        let singleOrderingCountIfEquallyDistributed = Double(totalCount) / permutations
        let accuracy: Double = 0.97
        let minCount = Int(singleOrderingCountIfEquallyDistributed * accuracy)
        let maxCount = Int(singleOrderingCountIfEquallyDistributed / accuracy)
        
        for count in orderings {
            // swiftlint:disable empty_count
            if count == 0 {
                continue
            }
            
            XCTAssert(count >= minCount && count <= maxCount)
        }
    }
}

extension RandomNumberProvider {
    // Returns id of ordering, a number from 01234 to 43210
    func randomOrderingOfFiveElements() -> Int {
        return (0..<5)
            .map { index in (index, nextRandomNumber()) } // Example: [0]=0 [1]=8 [2]=23 [3]=5 [4]=6
            .sorted { lhs, rhs in lhs.1 < rhs.1 } // Example: [0]=(0,0) [1]=(3,5) [2]=(4,6) [3]=(1,8) [4]=(2,23)
            .map { $0.0 } // Example: [0]=0 [1]=3 [2]=4 [3]=1 [4]=2
            .reduce(0) { $0 * 10 + $1 } // Example: 3412
    }
}
