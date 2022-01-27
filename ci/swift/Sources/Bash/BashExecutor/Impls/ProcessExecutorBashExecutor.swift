import CiFoundation
import Foundation

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
        environment bashExecutorEnvironment: BashExecutorEnvironment,
        outputHandling: ProcessExecutorOutputHandling
    ) throws -> BashResult {
        let environment: [String: String]
            
        switch bashExecutorEnvironment {
        case .current:
            environment = environmentProvider.environment
        case .custom(let custom):
            environment = custom
        }
        
        let processResult = try processExecutor.execute(
            arguments: ["/bin/bash", "-l", "-c", command],
            currentDirectory: currentDirectory,
            environment: environment,
            outputHandling: outputHandling
        )
        
        return BashResult(
            processResult: processResult
        )
    }
}
