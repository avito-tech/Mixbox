public final class EmceeRunTestsOnRemoteQueueCommandArguments {
    // Simple args
    public let priority: Int
    public let runId: String
    
    // Configs
    public let destinations: String
    public let testArgFile: String
    public let queueServerDestination: String
    public let queueServerRunConfigurationLocation: String
    
    // Code being tested
    public let runner: String?
    public let app: String
    public let additionalApps: [String]
    public let xctestBundle: String
    
    // Common (local/remote/shared queues)
    public let fbxctest: String
    public let junit: String
    public let trace: String
    public let testDestinations: String
    
    // For unit tests
    public let fbsimctl: String?
    
    public init(
        priority: Int,
        runId: String,
        destinations: String,
        testArgFile: String,
        queueServerDestination: String,
        queueServerRunConfigurationLocation: String,
        runner: String?,
        app: String,
        additionalApps: [String],
        xctestBundle: String,
        fbxctest: String,
        junit: String,
        trace: String,
        testDestinations: String,
        fbsimctl: String?)
    {
        self.priority = priority
        self.runId = runId
        self.destinations = destinations
        self.testArgFile = testArgFile
        self.queueServerDestination = queueServerDestination
        self.queueServerRunConfigurationLocation = queueServerRunConfigurationLocation
        self.runner = runner
        self.app = app
        self.additionalApps = additionalApps
        self.xctestBundle = xctestBundle
        self.fbxctest = fbxctest
        self.junit = junit
        self.trace = trace
        self.testDestinations = testDestinations
        self.fbsimctl = fbsimctl
    }
}
