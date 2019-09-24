import Foundation

public protocol ProcessOutput {
    var data: Data { get }
}

extension ProcessOutput {
    public func utf8String() -> String? {
        return String(data: data, encoding: .utf8)
    }
    
    public func trimmedUtf8String() -> String? {
        return utf8String()?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
