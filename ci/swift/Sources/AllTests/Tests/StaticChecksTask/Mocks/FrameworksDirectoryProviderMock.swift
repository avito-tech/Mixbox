import StaticChecksTask

public final class FrameworksDirectoryProviderMock: FrameworksDirectoryProvider {
    private let stubbedFrameworksDirectory: String
    
    public init(frameworksDirectory: String) {
        self.stubbedFrameworksDirectory = frameworksDirectory
    }
    
    public func frameworksDirectory() throws -> String {
        return stubbedFrameworksDirectory
    }
}
