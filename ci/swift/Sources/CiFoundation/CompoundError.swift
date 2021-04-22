public final class CompoundError: Error, CustomStringConvertible {
    private let message: String
    private let errors: [Error]
    
    public init(
        message: String,
        errors: [Error])
    {
        self.message = message
        self.errors = errors
    }
    
    public var description: String {
        return "\(message), nested errors: \(errors)"
    }
}
