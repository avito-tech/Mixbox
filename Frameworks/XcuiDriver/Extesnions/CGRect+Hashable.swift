import MixboxFoundation

extension CGRect: Hashable {
    public var hashValue: Int {
        return HashMath
            .combine(origin.x)
            .combine(origin.y)
            .combine(size.width)
            .combine(size.height)
            .reduce
    }
}
