public final class PosixFunctionError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    public let functionName: String
    public let result: Int
    public let errno: Int32?
    
    public init(functionName: String, result: Int, errno: Int32?) {
        self.functionName = functionName
        self.result = result
        self.errno = errno
    }
    
    @objc public var description: String {
        return "\(functionName) failed with result: \(result)" + (errno.map { ", errno: \($0)" } ?? "")
    }
    
    public var debugDescription: String {
        return description
    }
}
