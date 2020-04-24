import Models
import Foundation

public final class EmceeDumpCommandArguments {
    public let xctestBundle: String
    public let fbxctest: String
    public let testDestinationConfigurations: [TestDestinationConfiguration]
    public let appPath: String?
    public let fbsimctl: URL
    public let tempFolder: String
    
    public init(
        xctestBundle: String,
        fbxctest: String,
        testDestinationConfigurations: [TestDestinationConfiguration],
        appPath: String?,
        fbsimctl: URL,
        tempFolder: String)
    {
        self.xctestBundle = xctestBundle
        self.fbxctest = fbxctest
        self.testDestinationConfigurations = testDestinationConfigurations
        self.appPath = appPath
        self.fbsimctl = fbsimctl
        self.tempFolder = tempFolder
    }
}
