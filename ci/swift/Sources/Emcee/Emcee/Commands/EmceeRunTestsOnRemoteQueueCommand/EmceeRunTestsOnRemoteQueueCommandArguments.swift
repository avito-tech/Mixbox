public final class EmceeRunTestsOnRemoteQueueCommandArguments {
    // Simple args
    public let runId: String
    
    // Configs
    public let testArgFile: String
    public let queueServerDestination: String
    public let queueServerRunConfigurationLocation: String
    
    // Required args
    public let tempFolder: String
    
    // Common (local/remote/shared queues)
    public let fbxctest: String
    public let junit: String
    public let trace: String
    
    // For unit tests
    public let fbsimctl: String?
    
    public init(
        runId: String,
        testArgFile: String,
        queueServerDestination: String,
        queueServerRunConfigurationLocation: String,
        tempFolder: String,
        fbxctest: String,
        junit: String,
        trace: String,
        fbsimctl: String?)
    {
        self.runId = runId
        self.testArgFile = testArgFile
        self.queueServerDestination = queueServerDestination
        self.queueServerRunConfigurationLocation = queueServerRunConfigurationLocation
        self.tempFolder = tempFolder
        self.fbxctest = fbxctest
        self.junit = junit
        self.trace = trace
        self.fbsimctl = fbsimctl
    }
}
