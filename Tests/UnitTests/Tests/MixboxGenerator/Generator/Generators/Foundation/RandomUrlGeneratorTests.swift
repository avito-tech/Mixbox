import MixboxGenerators
import XCTest

final class RandomUrlGeneratorTests: TestCase {
    func test() {
        let generator = RandomUrlGenerator(
            randomNumberProvider: SequenceRandomNumberProvider(
                sequence: Array(0..<20),
                continuation: nil
            )
        )
        
        // Generator doesn't care if it will be good looking or no.
        // It should successfully generate intance of type URL.
        // This test also checks if implementation isn't changed,
        // if it is changed, tests should test new implementation (maybe it
        // would be more complex?)
        let url = URL(string: "abcdefghijklmnopqrst").unwrapOrFail()
        XCTAssertEqual(try generator.generate(), url)
    }
}
