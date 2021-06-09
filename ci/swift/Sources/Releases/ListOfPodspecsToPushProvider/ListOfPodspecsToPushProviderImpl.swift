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
    
    public func listOfPodspecsToPush() throws -> [JsonPodspec] {
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
            environment: nil,
            shouldThrowOnNonzeroExitCode: true
        )
        
        let listOfPodspecs = try JSONDecoder().decode(
            [JsonPodspec].self,
            from: result.stdout.trimmedUtf8String().unwrapOrThrow().data(using: .utf8).unwrapOrThrow()
        )
        
        let unsupportedPodspecs: Set<String> = [
            // Neither of these pods exists in trunk (as of 2021.03.18):
            //
            // - SourceryFramework
            // - SourceryUtils
            // - SourceryRuntime
            //
            // So `MixboxMocksGeneration` can't be released to trunk.
            // However, that's not a problem since it can be used via SPM,
            // and releasing it to Cocoapods is not a priority.
            //
            // We can make PR to https://github.com/krzysztofzablocki/Sourcery,
            // there are scripts for deploying pods and those frameworks
            // (podspecs were added by one of the authors of Mixbox to Sourcery)
            // aren't in that script. The community there is welcoming.
            //
            "MixboxMocksGeneration"
        ]
        
        return listOfPodspecs.filter { podspec in
            !unsupportedPodspecs.contains(podspec.name)
        }
    }
}
