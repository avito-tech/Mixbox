import Models
import Foundation

public final class EmceeDumpCommandArguments {
    public let xctestBundle: String
    public let fbxctest: String
    public let testDestinationConfigurations: [TestDestinationConfiguration]
    public let appPath: String?
    public let tempFolder: String
    
    public init(
        xctestBundle: String,
        fbxctest: String,
        testDestinationConfigurations: [TestDestinationConfiguration],
        appPath: String?,
        tempFolder: String)
    {
        self.xctestBundle = xctestBundle
        self.fbxctest = fbxctest
        self.testDestinationConfigurations = testDestinationConfigurations
        self.appPath = appPath
        self.tempFolder = tempFolder
    }
}
