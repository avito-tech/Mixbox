public protocol Retrier: class {
    func retry<T>(
        firstAttempt: () -> T,
        everyNextAttempt: () -> T,
        shouldRetry: (T) -> Bool,
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        -> T
}

extension Retrier {
    public func retry<T>(
        attempt: () -> T,
        shouldRetry: (T) -> Bool,
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        -> T
    {
        return retry(
            firstAttempt: attempt,
            everyNextAttempt: attempt,
            shouldRetry: shouldRetry,
            isPossibleToRetryProvider: isPossibleToRetryProvider
        )
    }
}
