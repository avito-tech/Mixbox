import MixboxGenerators

final class ConstantRandomNumberProvider: RandomNumberProvider {
    private let constant: UInt64
    
    init(_ constant: UInt64) {
        self.constant = constant
    }
    
    func nextRandomNumber() -> UInt64 {
        return constant
    }
}
