#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// Same as FileLine, but with String instead of StaticString.
// Sometimes you can't use StaticString (for non-static strings, obviously).
//
// Unfortunately, it is used less commonly because, unfortunately, StaticString exists
// and some functions require it (like XCTAssert, etc).
//
public final class RuntimeFileLine: Codable, Equatable, Hashable {
    public let file: String
    public let line: UInt
    
    public init(
        file: String,
        line: UInt)
    {
        self.file = file
        self.line = line
    }
    
    public convenience init(
        file: StaticString,
        line: UInt)
    {
        self.init(
            file: String(describing: file),
            line: line
        )
    }
    
    public convenience init(
        fileLine: FileLine)
    {
        self.init(
            file: fileLine.file,
            line: fileLine.line
        )
    }
    
    public static func ==(left: RuntimeFileLine, right: RuntimeFileLine) -> Bool {
        return left.file == right.file
            && left.line == right.line
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(file)
        hasher.combine(line)
    }
}

#endif
