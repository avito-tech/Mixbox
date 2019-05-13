public protocol ImageHashCalculator {
    func imageHash(image: UIImage) -> UInt64
    func hashDistance(lhsHash: UInt64, rhsHash: UInt64) -> UInt8
}
