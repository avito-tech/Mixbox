import Foundation

public final class RetrierImpl: Retrier {
    public init() {
    }
    
    public func retry<T>(
        timeouts: [TimeInterval],
        body: () throws -> T)
        throws
        -> T
    {
        var errors = [Error]()
        
        for timeout in [0] + timeouts {
            if timeout > 0 {
                Thread.sleep(forTimeInterval: timeout)
            }
            
            do {
                return try body()
            } catch {
                errors.append(error)
            }
        }
        
        throw CompoundError(
            message: "Failed to perfrom operation with timeouts \(timeouts)",
            errors: errors
        )
    }
}
