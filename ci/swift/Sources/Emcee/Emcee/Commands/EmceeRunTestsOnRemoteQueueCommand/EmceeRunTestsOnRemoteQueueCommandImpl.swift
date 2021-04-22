import CiFoundation

public final class EmceeRunTestsOnRemoteQueueCommandImpl: EmceeRunTestsOnRemoteQueueCommand {
    private let emceeExecutable: EmceeExecutable
    private let remoteCacheConfigProvider: RemoteCacheConfigProvider
    private let emceeVersionProvider: EmceeVersionProvider
    private let retrier: Retrier
    
    public init(
        emceeExecutable: EmceeExecutable,
        remoteCacheConfigProvider: RemoteCacheConfigProvider,
        emceeVersionProvider: EmceeVersionProvider,
        retrier: Retrier)
    {
        self.emceeExecutable = emceeExecutable
        self.remoteCacheConfigProvider = remoteCacheConfigProvider
        self.emceeVersionProvider = emceeVersionProvider
        self.retrier = retrier
    }
    
    public func runTestsOnRemoteQueue(
        arguments: EmceeRunTestsOnRemoteQueueCommandArguments)
        throws
    {
        let staticArguments = [
            "--test-arg-file", arguments.testArgFile,
            "--queue-server-configuration-location", arguments.queueServerRunConfigurationLocation,
            "--junit", arguments.junit,
            "--trace", arguments.trace,
            "--temp-folder", arguments.tempFolder,
            "--remote-cache-config", try remoteCacheConfigProvider.remoteCacheConfigJsonFilePath()
        ]
        
        // Fails very often with:
        // ```
        //  Runtime dump did not create a JSON file at expected location
        // ```
        try retrier.retry(retries: 3) {
            try emceeExecutable.execute(
                command: "runTestsOnRemoteQueue",
                arguments: staticArguments
            )
        }
    }
}
