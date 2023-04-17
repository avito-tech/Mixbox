import TestArgFile
import Foundation
import BuildArtifactsApple

public final class EmceeDumpCommandArguments {
    public let jobId: String
    public let iosBuildArtifacts: AppleBuildArtifacts
    public let testDestinationConfigurations: [TestDestinationConfiguration]
    public let tempFolder: String
    
    public init(
        jobId: String,
        iosBuildArtifacts: AppleBuildArtifacts,
        testDestinationConfigurations: [TestDestinationConfiguration],
        tempFolder: String)
    {
        self.jobId = jobId
        self.iosBuildArtifacts = iosBuildArtifacts
        self.testDestinationConfigurations = testDestinationConfigurations
        self.tempFolder = tempFolder
    }
}
