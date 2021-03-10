public protocol Retrier: class {
    func retry<T>(
        firstAttempt: () throws -> T,
        everyNextAttempt: () throws -> T,
        shouldRetry: (T) throws -> Bool,
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        rethrows
        -> T
}

extension Retrier {
    public func retry<T>(
        attempt: () throws -> T,
        shouldRetry: (T) throws -> Bool,
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        rethrows
        -> T
    {
        return try retry(
            firstAttempt: attempt,
            everyNextAttempt: attempt,
            shouldRetry: shouldRetry,
            isPossibleToRetryProvider: isPossibleToRetryProvider
        )
    }
}
