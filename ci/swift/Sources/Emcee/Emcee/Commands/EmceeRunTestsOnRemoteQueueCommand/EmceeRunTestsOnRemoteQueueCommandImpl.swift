public final class EmceeRunTestsOnRemoteQueueCommandImpl: EmceeRunTestsOnRemoteQueueCommand {
    private let emceeExecutable: EmceeExecutable
    
    public init(emceeExecutable: EmceeExecutable) {
        self.emceeExecutable = emceeExecutable
    }
    
    public func runTestsOnRemoteQueue(
        arguments: EmceeRunTestsOnRemoteQueueCommandArguments)
        throws
    {        
        let staticArguments = [
            "--run-id", arguments.runId,
            "--test-arg-file", arguments.testArgFile,
            "--queue-server-destination", arguments.queueServerDestination,
            "--queue-server-run-configuration-location", arguments.queueServerRunConfigurationLocation,
            "--fbxctest", arguments.fbxctest,
            "--junit", arguments.junit,
            "--trace", arguments.trace,
            "--temp-folder", arguments.tempFolder
        ]
        
        let dynamicArguments = []
            + arguments.fbsimctl.toArray { ["--fbsimctl", $0] }
        
        try emceeExecutable.execute(
            command: "runTestsOnRemoteQueue",
            arguments: staticArguments + dynamicArguments
        )
    }
}
