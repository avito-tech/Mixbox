public final class DelegatingEmcee:
    Emcee,
    EmceeDumpCommandHolder,
    EmceeRunTestsOnRemoteQueueCommandHolder
{
    public let emceeDumpCommand: EmceeDumpCommand
    public let emceeRunTestsOnRemoteQueueCommand: EmceeRunTestsOnRemoteQueueCommand
    
    public init(
        emceeDumpCommand: EmceeDumpCommand,
        emceeRunTestsOnRemoteQueueCommand: EmceeRunTestsOnRemoteQueueCommand)
    {
        self.emceeDumpCommand = emceeDumpCommand
        self.emceeRunTestsOnRemoteQueueCommand = emceeRunTestsOnRemoteQueueCommand
    }
}
