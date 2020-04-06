import MixboxGenerator
import MixboxTestsFoundation

final class SequenceAnyGenerator: AnyGenerator {
    private let sequence: [Any]
    private var index: Int = 0
    
    init(_ sequence: [Any]) {
        self.sequence = sequence
    }
    
    func generate<T>() throws -> T {
        if index > sequence.count {
            UnavoidableFailure.fail("\(self) has only \(sequence.count) elements, element \(index) was requested")
        }
        
        let result = try (sequence[index] as? T).unwrapOrThrow()
        index += 1
        return result
    }
}
