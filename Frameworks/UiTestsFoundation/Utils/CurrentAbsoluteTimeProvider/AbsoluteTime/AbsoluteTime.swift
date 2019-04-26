public final class AbsoluteTime {
    public let hi: UInt32
    public let lo: UInt32
    
    // It is not easy to get AbsoluteTime from Swift. Proof:
    // https://stackoverflow.com/questions/36818402/absolutetime-type-not-imported-into-swift
    //
    // `AbsoluteTime` C type can not be exported to Swift. However, if the type is not defined, we
    // can pass the value anywhere, from C to Swift and vice versa.
    // Here is a kludge with lazy var to not mention type in Swift code.
    public private(set) lazy var cAbsoluteTime = mixbox_absoluteTime(hi, lo)
    
    public init(hi: UInt32, lo: UInt32) {
        self.hi = hi
        self.lo = lo
    }
}
