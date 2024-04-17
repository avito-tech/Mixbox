#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// "Line" as a source code location can be represented by various types.
//
// Examples:
//
// XCTFail: UInt
// XCTestCase.recordFailure (original Objective-C API): UInt
// XCTestCase.recordFailure (rebinded for Swift): Int (yes, it is not logical)
// XCSymbolicationRecord: UInt64
// XCTSourceCodeLocation: Int
//
// This class safely converts types, in case of error it defaults to `0`, which works great
// and is widely used as a fallback value in many software.
public final class SourceCodeLineTypeConverter {
    private init() {
    }
    
    public static func convert<Line: BinaryInteger, Result: SignedInteger>(
        line: Line,
        to type: Result.Type = Result.self)
        -> Result
    {
        return Result(exactly: line) ?? 0
    }
    
    public static func convert<Line: BinaryInteger, Result: UnsignedInteger>(
        line: Line,
        to type: Result.Type = Result.self)
        -> Result
    {
        return Result(exactly: line) ?? 0
    }
}

#endif
