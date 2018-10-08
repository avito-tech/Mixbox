public protocol ImageHashCalculator {
    func imageHash(image: UIImage) -> UInt64
}
