// A wrapper of String that is also an Error,
// it could be trown or returned:
//
// func doMagic() -> String?
// func doMagic() -> ErrorString? // looks better
//
public final class ErrorString: Error, ExpressibleByStringLiteral, CustomStringConvertible {
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public convenience init(stringLiteral: String) {
        self.init(stringLiteral)
    }
    
    public var description: String {
        return value
    }
}
