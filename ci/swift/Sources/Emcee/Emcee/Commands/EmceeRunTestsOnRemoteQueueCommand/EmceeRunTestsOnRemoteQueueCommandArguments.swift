public final class EmceeRunTestsOnRemoteQueueCommandArguments {
    // Simple args
    public let jobId: String
    
    // Configs
    public let testArgFile: String
    public let queueServerRunConfigurationLocation: String
    
    // Required args
    public let tempFolder: String
    
    // Common (local/remote/shared queues)
    public let junit: String
    public let trace: String
    
    public init(
        jobId: String,
        testArgFile: String,
        queueServerRunConfigurationLocation: String,
        tempFolder: String,
        junit: String,
        trace: String)
    {
        self.jobId = jobId
        self.testArgFile = testArgFile
        self.queueServerRunConfigurationLocation = queueServerRunConfigurationLocation
        self.tempFolder = tempFolder
        self.junit = junit
        self.trace = trace
    }
}
