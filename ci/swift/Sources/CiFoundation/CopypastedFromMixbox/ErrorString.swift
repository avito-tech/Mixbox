// NOTE: COPYPASTED FROM MIXBOX
//
// A wrapper of String that is also an Error,
// it could be trown or returned:
//
// func doMagic() -> String?
// func doMagic() -> ErrorString? // looks better
//
public final class ErrorString: Error, Codable, CustomStringConvertible {
    public let value: String
    public let file: String
    public let line: UInt
    
    public init(_ value: String, file: StaticString = #file, line: UInt = #line) {
        self.value = value
        self.file = String(describing: file)
        self.line = line
    }
    
    public var description: String {
        return value
    }
}
