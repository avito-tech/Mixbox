import Foundation

public final class NonZeroExitCodeBashError: LocalizedError, CustomStringConvertible {
    public let bashResult: BashResult
    
    public init(
        bashResult: BashResult)
    {
        self.bashResult = bashResult
    }
    
    public var errorDescription: String? {
        return bashResult.description
    }
    
    public var description: String {
        return bashResult.description
    }
}
