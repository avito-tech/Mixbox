import Cocoapods
import Git
import Foundation
import CiFoundation

public final class MixboxPodspecsValidatorImpl: MixboxPodspecsValidator {
    private let repoRootProvider: RepoRootProvider
    private let listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider
    private let cocoapodCacheClean: CocoapodCacheClean
    private let cocoapodsRepoAdd: CocoapodsRepoAdd
    private let cocoapodsRepoPush: CocoapodsRepoPush
    private let environmentProvider: EnvironmentProvider
    private let podspecsPatcher: PodspecsPatcher
    
    private let sandboxRepoName: String
    
    public init(
        repoRootProvider: RepoRootProvider,
        listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider,
        cocoapodCacheClean: CocoapodCacheClean,
        cocoapodsRepoAdd: CocoapodsRepoAdd,
        cocoapodsRepoPush: CocoapodsRepoPush,
        environmentProvider: EnvironmentProvider,
        podspecsPatcher: PodspecsPatcher)
    {
        self.repoRootProvider = repoRootProvider
        self.listOfPodspecsToPushProvider = listOfPodspecsToPushProvider
        self.cocoapodCacheClean = cocoapodCacheClean
        self.cocoapodsRepoAdd = cocoapodsRepoAdd
        self.cocoapodsRepoPush = cocoapodsRepoPush
        self.environmentProvider = environmentProvider
        self.podspecsPatcher = podspecsPatcher
        
        self.sandboxRepoName = "MixboxSandboxRepo-\(UUID().uuidString)"
    }
    
    public func validateMixboxPodspecs() throws {
        defer {
            try? cleanUpFileSystem()
        }
        try cleanUpState()
        try pushPodspecsToSandboxRepo()
    }
    
    private func cleanUpState() throws {
        try cocoapodCacheClean.clean(target: .all)
        try cleanUpFileSystem()
    }
    
    private func cleanUpFileSystem() throws {
        let fileManager = FileManager()
        let home = try homeDirectory()
        
        try? fileManager.removeItem(atPath: "\(home)/Library/Caches/CocoaPods/Pods")
        try? fileManager.removeItem(atPath: "\(home)/Library/Developer/Xcode/DerivedData/")
        try? fileManager.removeItem(atPath: try localSpecRepoPath())
    }
    
    private func pushPodspecsToSandboxRepo() throws {
        let repoRootPath = try repoRootProvider.repoRootPath()
        
        try cocoapodsRepoAdd.add(
            repoName: sandboxRepoName,
            url: repoRootPath
        )
        
        let sources = [
            "\(sandboxRepoName)",
            "https://cdn.cocoapods.org/"
        ]
        
        defer { try? podspecsPatcher.resetMixboxPodspecsSource() }
        try podspecsPatcher.setMixboxPodspecsSource("file://\(repoRootPath)")
        
        let listOfPodspecsToPush = try listOfPodspecsToPushProvider.listOfPodspecsToPush()
        
        try listOfPodspecsToPush.forEach { podspecName in
            try cocoapodsRepoPush.push(
                repoName: sandboxRepoName,
                pathToPodspec: repoRootPath.appending(
                    pathComponent: "\(podspecName).podspec"
                ),
                verbose: true,
                localOnly: true,
                allowWarnings: true,
                skipImportValidation: true,
                skipTests: true,
                useJson: true,
                sources: sources
            )
        }
    }
    
    private func homeDirectory() throws -> String {
        return try environmentProvider.environment["HOME"].unwrapOrThrow()
    }
    
    private func localSpecRepoPath() throws -> String {
        return "\(try homeDirectory())/.cocoapods/repos/\(sandboxRepoName)"
    }
}
