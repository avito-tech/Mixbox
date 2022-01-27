import TestArgFile
import Foundation
import BuildArtifacts

public final class EmceeDumpCommandArguments {
    public let jobId: String
    public let iosBuildArtifacts: IosBuildArtifacts
    public let testDestinationConfigurations: [TestDestinationConfiguration]
    public let tempFolder: String
    
    public init(
        jobId: String,
        iosBuildArtifacts: IosBuildArtifacts,
        testDestinationConfigurations: [TestDestinationConfiguration],
        tempFolder: String)
    {
        self.jobId = jobId
        self.iosBuildArtifacts = iosBuildArtifacts
        self.testDestinationConfigurations = testDestinationConfigurations
        self.tempFolder = tempFolder
    }
}
