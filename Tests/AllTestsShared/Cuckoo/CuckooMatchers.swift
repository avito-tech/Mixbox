import MixboxMocksRuntime
import MixboxTestsFoundation

public func isInstance<ActualType, ExpectedType>(of type: ExpectedType.Type) -> Matcher<ActualType> {
    if type != ExpectedType.self {
        UnavoidableFailure.fail(
            """
            Argument `type` of `isInstance` should be same type as generic parameter `U`. \
            The argument exists only for type inference. Runtime type checking is not supported.
            """
        )
    }
    
    return IsInstanceOfTypeMatcher<ActualType, ExpectedType>()
}
