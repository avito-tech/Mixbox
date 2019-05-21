import Foundation

public final class BashOutput {
    private let processOutput: ProcessOutput
    
    public init(processOutput: ProcessOutput) {
        self.processOutput = processOutput
    }
    
    public var data: Data {
        return processOutput.data
    }
    
    public func utf8String() -> String? {
        return String(data: processOutput.data, encoding: .utf8)
    }
    
    public func trimmedUtf8String() -> String? {
        return utf8String()?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
