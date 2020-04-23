#if MIXBOX_ENABLE_IN_APP_SERVICES

// A wrapper of String that is also an Error,
// it could be trown or returned:
//
// func doMagic() -> String?
// func doMagic() -> ErrorString? // looks better
//
open class ErrorString: Error, Hashable, Codable, ExpressibleByStringLiteral, CustomStringConvertible {
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public required convenience init(stringLiteral: String) {
        self.init(stringLiteral)
    }
    
    public convenience init(_ other: Error) {
        self.init(String(describing: other))
    }
    
    public var description: String {
        return value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    public static func ==(lhs: ErrorString, rhs: ErrorString) -> Bool {
        return lhs.value == rhs.value
    }
}

#endif
