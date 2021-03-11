import Git
import Bundler
import CiFoundation
import Foundation

public final class ListOfPodspecsToPushProviderImpl: ListOfPodspecsToPushProvider {
    private let bundledProcessExecutor: BundledProcessExecutor
    private let repoRootProvider: RepoRootProvider
    
    public init(
        bundledProcessExecutor: BundledProcessExecutor,
        repoRootProvider: RepoRootProvider)
    {
        self.bundledProcessExecutor = bundledProcessExecutor
        self.repoRootProvider = repoRootProvider
    }
    
    public func listOfPodspecsToPush() throws -> [String] {
        let getMixboxDependenciesScriptPath = try repoRootProvider
            .repoRootPath()
            .appending(
                pathComponents: [
                    "cocoapods",
                    "get_mixbox_dependencies_ordered_by_same_order_that_they_should_be_pushed.rb"
                ]
            )
        
        let result = try bundledProcessExecutor.execute(
            arguments: [
                "ruby",
                getMixboxDependenciesScriptPath
            ],
            currentDirectory: nil,
            environment: nil
        )
        
        if result.code != 0 {
            throw ErrorString(
                """
                ruby get_mixbox_dependencies.rb failed with exit code \(result.code), \
                stdout: \(result.stdout.trimmedUtf8String() ?? ""), \
                stderr: \(result.stderr.trimmedUtf8String() ?? "")
                """
            )
        }
        
        return try JSONDecoder().decode(
            [String].self,
            from: result.stdout.trimmedUtf8String().unwrapOrThrow().data(using: .utf8).unwrapOrThrow()
        )
    }
}
