// TODO: Rename. Note that the file with destinations (represented by `Destination`)
// is reused as is for Emcee, which is wrong. We should have configs describing devices,
// we should generate Emcee specific configs from them.
public final class TestDestination: Codable {
    public let deviceType: String // Example: "iPhone 7",
    public let iOSVersion: String // Example: "11.3",
    public let iOSVersionShort: String // Example: "11.3",
    public let iOSVersionLong: String // Example: "11.3",
    public let deviceTypeId: String // Example: "com.apple.CoreSimulator.SimDeviceType.iPhone-7",
    public let runtimeId: String // Example: "com.apple.CoreSimulator.SimRuntime.iOS-11-3"
    
    public init(
        deviceType: String,
        iOSVersion: String,
        iOSVersionShort: String,
        iOSVersionLong: String,
        deviceTypeId: String,
        runtimeId: String)
    {
        self.deviceType = deviceType
        self.iOSVersion = iOSVersion
        self.iOSVersionShort = iOSVersionShort
        self.iOSVersionLong = iOSVersionLong
        self.deviceTypeId = deviceTypeId
        self.runtimeId = runtimeId
    }
}

public final class Destination: Codable {
    public final class ReportOutput: Codable {
        public let junit: String
        public let tracingReport: String
        
        public init(
            junit: String,
            tracingReport: String)
        {
            self.junit = junit
            self.tracingReport = tracingReport
        }
    }
    
    public let testDestination: TestDestination
    public let reportOutput: ReportOutput
    
    public init(
        testDestination: TestDestination,
        reportOutput: ReportOutput)
    {
        self.testDestination = testDestination
        self.reportOutput = reportOutput
    }
}
