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
            "--priority", String(arguments.priority),
            "--run-id", arguments.runId,
            "--destinations", arguments.destinations,
            "--test-arg-file", arguments.testArgFile,
            "--queue-server-destination", arguments.queueServerDestination,
            "--queue-server-run-configuration-location", arguments.queueServerRunConfigurationLocation,
            "--app", arguments.app,
            "--xctest-bundle", arguments.xctestBundle,
            "--fbxctest", arguments.fbxctest,
            "--junit", arguments.junit,
            "--trace", arguments.trace,
            "--test-destinations", arguments.testDestinations
        ]
        
        let dynamicArguments = []
            + arguments.runner.toArray { ["--runner", $0] }
            + arguments.fbsimctl.toArray { ["--fbsimctl", $0] }
            + arguments.additionalApps.flatMap { ["--additional-app", $0] }
        
        try emceeExecutable.execute(
            command: "runTestsOnRemoteQueue",
            arguments: staticArguments + dynamicArguments
        )
    }
}
