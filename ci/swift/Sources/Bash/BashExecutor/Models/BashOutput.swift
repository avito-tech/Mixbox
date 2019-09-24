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
        return processOutput.utf8String()
    }
    
    public func trimmedUtf8String() -> String? {
        return processOutput.trimmedUtf8String()
    }
}
