import MixboxFoundation

// Difference from FileLine:
//
// - FileLine has file: StaticString (compatible with XCTFail)
// - HeapFileLine has file: String (compatible with XCTestCase.recordFailure)
//
public final class HeapFileLine: Hashable, CustomStringConvertible {
    public let file: String
    public let line: UInt64
    
    public init(
        file: String,
        line: UInt64)
    {
        self.file = file
        self.line = line
    }
    
    convenience init(
        fileLine: FileLine)
    {
        self.init(
            file: "\(fileLine.file)",
            line: UInt64(fileLine.line)
        )
    }
    
    public static func ==(left: HeapFileLine, right: HeapFileLine) -> Bool {
        return left.file == right.file
            && left.line == right.line
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(file)
        hasher.combine(line)
    }
    
    public var description: String {
        return "HeapFileLine(file: \(file), line: \(line))"
    }
}
