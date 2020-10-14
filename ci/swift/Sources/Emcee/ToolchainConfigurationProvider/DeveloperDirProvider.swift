import DeveloperDirModels

public protocol DeveloperDirProvider {
    func developerDir() throws -> DeveloperDir
}
