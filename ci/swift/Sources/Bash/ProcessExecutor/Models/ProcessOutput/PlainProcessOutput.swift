import Foundation

public final class PlainProcessOutput: ProcessOutput {
    public let data: Data
    
    public init(data: Data) {
        self.data = data
    }
}
