import Bash
import CiFoundation

public final class SimctlExecutorImpl: SimctlExecutor {
    private let processExecutor: ProcessExecutor
    private let environmentProvider: EnvironmentProvider
    
    public init(
        processExecutor: ProcessExecutor,
        environmentProvider: EnvironmentProvider)
    {
        self.processExecutor = processExecutor
        self.environmentProvider = environmentProvider
    }
    
    public func execute(arguments: [String]) throws -> ProcessResult {
        try processExecutor.executeOrThrow(
            arguments: ["/usr/bin/xcrun", "simctl"] + arguments,
            environmentProvider: environmentProvider,
            outputHandling: .ignore
        )
    }
}
