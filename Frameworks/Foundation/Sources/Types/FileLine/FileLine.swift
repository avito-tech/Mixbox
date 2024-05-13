#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// File and line always goes together.
//
// It is much simpler to pass one argument through many functions than two arguments.
// Also it is useful in protocols.
//
// Example usage:
//
//  public protocol SuperTestUtility: AnyObject {
//      func makeLifeEasier(fileLine: FileLine)
//  }
//
//  public extension SuperTestUtility {
//      func makeLifeEasier(file: StaticString = #filePath, line: UInt = #line) {
//          makeLifeEasier(fileLine: FileLine(file: file, line: line))
//      }
//  }
//
// We cant use function with same signature in protocol extension, because
// it would cause stack overflow. So FileLine is useful also for this case.

public final class FileLine: Hashable, CustomStringConvertible {
    public let file: StaticString
    public let line: UInt
    
    public init(
        file: StaticString,
        line: UInt)
    {
        self.file = file
        self.line = line
    }
    
    public static func ==(left: FileLine, right: FileLine) -> Bool {
        return String(describing: left.file) == String(describing: right.file)
            && left.line == right.line
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: file))
        hasher.combine(line)
    }
    
    public var description: String {
        return "\(file):\(line)"
    }
}

extension FileLine {
    // Remember that it can not be used as a default argument of a function if you
    // want to store the file and line of where the function was called.
    //
    // E.g.:
    //
    // 0: func x(fileLine: FileLine = .current()) {}
    // 1: func y(file: StaticString = #filePath, UInt = #line) {}
    // 2:
    // 3: x() // line: 0, where .current() was used
    // 4: y() // line: 4, this line
    //
    public static func current(
        file: StaticString = #filePath,
        line: UInt = #line)
        -> FileLine
    {
        return FileLine(file: file, line: line)
    }
}

#endif
