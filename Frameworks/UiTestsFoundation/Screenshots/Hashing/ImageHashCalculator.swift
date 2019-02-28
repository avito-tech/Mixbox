public protocol ImageHashCalculator {
    func imageHash(image: UIImage) -> Int64
    func hashDistance(lhsHash: Int64, rhsHash: Int64) -> Int64
}
