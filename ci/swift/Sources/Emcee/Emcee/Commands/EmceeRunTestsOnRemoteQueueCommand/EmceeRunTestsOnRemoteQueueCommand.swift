public protocol EmceeRunTestsOnRemoteQueueCommand {
    func runTestsOnRemoteQueue(
        arguments: EmceeRunTestsOnRemoteQueueCommandArguments)
        throws
}

// Delegation

public protocol EmceeRunTestsOnRemoteQueueCommandHolder {
    var emceeRunTestsOnRemoteQueueCommand: EmceeRunTestsOnRemoteQueueCommand { get }
}

extension EmceeRunTestsOnRemoteQueueCommand where Self: EmceeRunTestsOnRemoteQueueCommandHolder {
    public func runTestsOnRemoteQueue(
        arguments: EmceeRunTestsOnRemoteQueueCommandArguments)
        throws
    {
        try emceeRunTestsOnRemoteQueueCommand.runTestsOnRemoteQueue(
            arguments: arguments
        )
    }
}
