import MixboxFoundation

public final class Stub {
    public let closure: (Any) -> Any
    public let matcher: FunctionalMatcher<Any>
    
    public init(
        closure: @escaping (Any) -> Any,
        matcher: FunctionalMatcher<Any>)
    {
        self.closure = closure
        self.matcher = matcher
    }
    
    public func matches<Arguments>(arguments: Arguments) -> Bool {
        return matcher.valueIsMatching(arguments)
    }
    
    public func value<Arguments, ReturnValue>(arguments: Arguments) throws -> ReturnValue {
        let returnValueAsAny = closure(arguments)
        
        if let returnValue = returnValueAsAny as? ReturnValue {
            return returnValue
        } else {
            throw ErrorString(
                """
                Return value of the stub was expected to be \
                of type \(ReturnValue.self), actual type: \(type(of: returnValueAsAny))
                """
            )
        }
    }
}
