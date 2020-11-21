// Note: copypasted from MixboxFoundation
public final class ErrorString: Error, CustomStringConvertible {
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public var description: String {
        return value
    }
}
