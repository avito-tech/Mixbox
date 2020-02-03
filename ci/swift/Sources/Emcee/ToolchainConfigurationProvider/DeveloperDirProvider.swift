import Models

public protocol DeveloperDirProvider {
    func developerDir() throws -> DeveloperDir
}
