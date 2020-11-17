import MixboxMocksRuntime

public func isInstance<T, U>(of type: U.Type) -> FunctionalMatcher<T> {
    return FunctionalMatcher<T> { $0 is U }
}
