import XCTest
import MixboxGenerators
import MixboxStubbing

extension BaseGeneratorFacadeTests {
    @nonobjc func generatedByDefault() -> Int {
        7830206022935481231
    }
    
    @nonobjc func generatedByDefault() -> String {
        "91F3EE65-E4C9-4206-BFC6-6945D4696FAC"
    }

    @nonobjc func generatedByDefault() -> Structure {
        Structure(
            int: generatedByDefault(),
            string: generatedByDefault()
        )
    }
    
    @nonobjc func setRandom(_ values: UInt64..., continueSequenceWithMoreNumbers: Bool = true) {
        setRandom(values)
    }
    
    @nonobjc func setRandom(_ values: [UInt64], continueSequenceWithMoreNumbers: Bool = true) {
        mocks.register(type: RandomNumberProvider.self) { _ in
            SequenceRandomNumberProvider(
                sequence: values,
                continuation: continueSequenceWithMoreNumbers
                    ? 5866480189500748096
                    : nil
            )
        }
    }
    
    @nonobjc func stubDefaultConstants() {
        let int: Int = generatedByDefault()
        mocks.register(type: Generator<Int>.self) { _ in
            ConstantGenerator(int)
        }
        
        let string: String = generatedByDefault()
        mocks.register(type: Generator<String>.self) { _ in
            ConstantGenerator(string)
        }
    }
}
