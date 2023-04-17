import DeveloperDirLocatorModels

public protocol DeveloperDirProvider {
    func developerDir() throws -> DeveloperDir
}
