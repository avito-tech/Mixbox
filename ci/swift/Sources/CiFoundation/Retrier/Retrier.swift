import Foundation

public protocol Retrier {
    func retry<T>(
        timeouts: [TimeInterval], // empty array means at least 1 attempt
        body: () throws -> T)
        throws
        -> T
}

extension Retrier {
    public func retry<T>(
        retries: Int, // retries count = X, total attempts countr = X + 1
        timeout: TimeInterval = 0,
        body: () throws -> T)
        throws
        -> T
    {
        return try retry(
            timeouts: Array(
                repeating: timeout,
                count: retries
            ),
            body: body
        )
    }
}
 
