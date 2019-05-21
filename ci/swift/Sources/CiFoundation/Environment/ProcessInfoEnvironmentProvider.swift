import Foundation

public final class ProcessInfoEnvironmentProvider: EnvironmentProvider {
    private let processInfo: ProcessInfo
    
    public init(processInfo: ProcessInfo) {
        self.processInfo = processInfo
    }
    
    public var environment: [String: String] {
        return processInfo.environment
    }
}
