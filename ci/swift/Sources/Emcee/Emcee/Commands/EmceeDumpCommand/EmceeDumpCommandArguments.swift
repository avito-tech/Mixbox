import TestArgFile
import Foundation

public final class EmceeDumpCommandArguments {
    public let jobId: String
    public let xctestBundle: String
    public let testDestinationConfigurations: [TestDestinationConfiguration]
    public let appPath: String?
    public let tempFolder: String
    
    public init(
        jobId: String,
        xctestBundle: String,
        testDestinationConfigurations: [TestDestinationConfiguration],
        appPath: String?,
        tempFolder: String)
    {
        self.jobId = jobId
        self.xctestBundle = xctestBundle
        self.testDestinationConfigurations = testDestinationConfigurations
        self.appPath = appPath
        self.tempFolder = tempFolder
    }
}
