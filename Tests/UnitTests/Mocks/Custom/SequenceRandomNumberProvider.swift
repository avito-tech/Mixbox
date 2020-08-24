import MixboxGenerators
import MixboxTestsFoundation

final class SequenceRandomNumberProvider: RandomNumberProvider {
    private let sequence: [UInt64]
    private let continuation: UInt64?
    private var index: Int = 0
    
    init(sequence: [UInt64], continuation: UInt64?) {
        self.sequence = sequence
        self.continuation = continuation
    }
    
    func nextRandomNumber() -> UInt64 {
        if index >= sequence.count {
            if let continuation = continuation {
                return continuation
            } else {
                UnavoidableFailure.fail("\(self) has only \(sequence.count) elements, element \(index) was requested")
            }
        }
        
        let result = sequence[index]
        index += 1
        return result
    }
}
