import MixboxGenerator
import MixboxTestsFoundation

final class SequenceRandomNumberProvider: RandomNumberProvider {
    private let sequence: [UInt64]
    private var index: Int = 0
    
    init(_ sequence: [UInt64]) {
        self.sequence = sequence
    }
    
    func nextRandomNumber() -> UInt64 {
        if index > sequence.count {
            UnavoidableFailure.fail("\(self) has only \(sequence.count) elements, element \(index) was requested")
        }
        
        let result = sequence[index]
        index += 1
        return result
    }
}
