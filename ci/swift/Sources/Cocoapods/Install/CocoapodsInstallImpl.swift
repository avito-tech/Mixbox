import Foundation
import CiFoundation

public final class CocoapodsInstallImpl: CocoapodsInstall {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    private let environmentProvider: EnvironmentProvider
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor,
        environmentProvider: EnvironmentProvider)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
        self.environmentProvider = environmentProvider
    }
    
    public func install(
        projectDirectory: String)
        throws
    {
        let cocoapods = CocoapodsInstallWithProjectDirectory(
            cocoapodsCommandExecutor: cocoapodsCommandExecutor,
            environmentProvider: environmentProvider,
            projectDirectory: projectDirectory
        )
        
        try cocoapods.install()
    }
}

// Simplifies working with arguments
private class CocoapodsInstallWithProjectDirectory {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    private let environmentProvider: EnvironmentProvider
    private let projectDirectory: String
    
    init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor,
        environmentProvider: EnvironmentProvider,
        projectDirectory: String)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
        self.environmentProvider = environmentProvider
        self.projectDirectory = projectDirectory
    }
    
    func install()
        throws
    {
        do {
            do {
                try execute(["install", "--verbose"])
            } catch {
                try execute(["install", "--repo-update", "--verbose"])
            }
        } catch {
            throw ErrorString("Failed to install pods in \(projectDirectory): \(error)")
        }
    }
    
    private func execute(_ arguments: [String]) throws {
        _ = try cocoapodsCommandExecutor.execute(
            arguments: arguments,
            currentDirectory: projectDirectory
        )
    }
}
