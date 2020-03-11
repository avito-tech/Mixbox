public final class EmceeRunTestsOnRemoteQueueCommandImpl: EmceeRunTestsOnRemoteQueueCommand {
    private let emceeExecutable: EmceeExecutable
    private let remoteCacheConfigProvider: RemoteCacheConfigProvider
    private let emceeVersionProvider: EmceeVersionProvider
    
    public init(
        emceeExecutable: EmceeExecutable,
        remoteCacheConfigProvider: RemoteCacheConfigProvider,
        emceeVersionProvider: EmceeVersionProvider)
    {
        self.emceeExecutable = emceeExecutable
        self.remoteCacheConfigProvider = remoteCacheConfigProvider
        self.emceeVersionProvider = emceeVersionProvider
    }
    
    public func runTestsOnRemoteQueue(
        arguments: EmceeRunTestsOnRemoteQueueCommandArguments)
        throws
    {
        let staticArguments = [
            "--emcee-version", emceeVersionProvider.emceeVersion(),
            "--run-id", arguments.runId,
            "--test-arg-file", arguments.testArgFile,
            "--queue-server-destination", arguments.queueServerDestination,
            "--queue-server-run-configuration-location", arguments.queueServerRunConfigurationLocation,
            "--junit", arguments.junit,
            "--trace", arguments.trace,
            "--temp-folder", arguments.tempFolder,
            "--remote-cache-config", try remoteCacheConfigProvider.remoteCacheConfigJsonFilePath()
        ]
        
        try emceeExecutable.execute(
            command: "runTestsOnRemoteQueue",
            arguments: staticArguments
        )
    }
}
