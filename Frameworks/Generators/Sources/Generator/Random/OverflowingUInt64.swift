#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

public struct OverflowingUInt64: ExpressibleByIntegerLiteral, Comparable {
    public typealias IntegerLiteralType = UInt64
    
    public let value: UInt64
    
    public init(_ value: UInt64) {
        self.value = value
    }
    
    public init(_ value: Int) {
        self.value = UInt64(value)
    }
    
    public init(integerLiteral value: UInt64) {
        self.value = value
    }
    
    public static func +(left: OverflowingUInt64, right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            left.value.addingReportingOverflow(right.value).partialValue
        )
    }
    
    public static func -(left: OverflowingUInt64, right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            left.value.subtractingReportingOverflow(right.value).partialValue
        )
    }
    
    public static func *(left: OverflowingUInt64, right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            left.value.multipliedReportingOverflow(by: right.value).partialValue
        )
    }
    
    public static func /(left: OverflowingUInt64, right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            left.value.dividedReportingOverflow(by: right.value).partialValue
        )
    }
    
    public static func <<(left: OverflowingUInt64, right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            left.value << right.value
        )
    }
    
    public static func >>(left: OverflowingUInt64, right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            left.value >> right.value
        )
    }
    
    public static func %(left: OverflowingUInt64, right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            left.value % right.value
        )
    }
    
    public static func &(left: OverflowingUInt64, right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            left.value & right.value
        )
    }
    
    public static func ^(left: OverflowingUInt64, right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            left.value ^ right.value
        )
    }
    
    public static prefix func ~(right: OverflowingUInt64) -> OverflowingUInt64 {
        return OverflowingUInt64(
            ~right.value
        )
    }
    
    public static func ==(left: OverflowingUInt64, right: OverflowingUInt64) -> Bool {
        return left.value == right.value
    }
    
    public static func <(left: OverflowingUInt64, right: OverflowingUInt64) -> Bool {
        return left.value < right.value
    }
}

#endif
