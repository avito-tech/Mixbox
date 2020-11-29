#if MIXBOX_ENABLE_IN_APP_SERVICES

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
