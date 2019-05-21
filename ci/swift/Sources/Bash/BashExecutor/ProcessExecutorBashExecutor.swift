import CiFoundation

public final class ProcessExecutorBashExecutor: BashExecutor {
    private let processExecutor: ProcessExecutor
    private let environmentProvider: EnvironmentProvider
    
    public init(
        processExecutor: ProcessExecutor,
        environmentProvider: EnvironmentProvider)
    {
        self.processExecutor = processExecutor
        self.environmentProvider = environmentProvider
    }
    
    public func execute(
        command: String,
        currentDirectory: String?,
        environment: [String: String]?)
        -> BashResult
    {
        let nonNilEnvironment = environment ?? environmentProvider.environment
        
        let processResult = processExecutor.execute(
            executable: "/bin/bash",
            arguments: ["-l", "-c", command],
            currentDirectory: currentDirectory,
            environment: nonNilEnvironment
        )
        
        return BashResult(
            processResult: processResult
        )
    }
}
