public final class MixboxTestDestinationConfiguration: Codable {
    public let testDestination: MixboxTestDestination
    public let reportOutput: ReportOutput
    
    public init(
        testDestination: MixboxTestDestination,
        reportOutput: ReportOutput)
    {
        self.testDestination = testDestination
        self.reportOutput = reportOutput
    }
}
