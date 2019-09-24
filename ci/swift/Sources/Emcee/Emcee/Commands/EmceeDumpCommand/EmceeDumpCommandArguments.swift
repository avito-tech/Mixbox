public final class EmceeDumpCommandArguments {
    public let xctestBundle: String
    public let fbxctest: String
    public let testDestinations: String // path to json
    public let appPath: String?
    public let fbsimctl: String?
    public let tempFolder: String
    
    public init(
        xctestBundle: String,
        fbxctest: String,
        testDestinations: String,
        appPath: String?,
        fbsimctl: String?,
        tempFolder: String)
    {
        self.xctestBundle = xctestBundle
        self.fbxctest = fbxctest
        self.testDestinations = testDestinations
        self.appPath = appPath
        self.fbsimctl = fbsimctl
        self.tempFolder = tempFolder
    }
}
