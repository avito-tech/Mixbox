import MixboxFoundation

public enum ThrowingFunctionResult<ReturnValue> {
    // Case when function returned value
    case returnValue(ReturnValue)
    
    // Case when function threw error
    case error(Error)
    
    func mapReturnValue<NewReturnValue>(
        transform: (ReturnValue) throws -> NewReturnValue)
        rethrows
        -> ThrowingFunctionResult<NewReturnValue>
    {
        switch self {
        case let .returnValue(nested):
            return .returnValue(try transform(nested))
        case let .error(nested):
            return .error(nested)
        }
    }
    
    func mapError(
        transform: (Error) throws -> Error)
        rethrows
        -> ThrowingFunctionResult
    {
        switch self {
        case let .returnValue(nested):
            return .returnValue(nested)
        case let .error(nested):
            return .error(try transform(nested))
        }
    }
}
