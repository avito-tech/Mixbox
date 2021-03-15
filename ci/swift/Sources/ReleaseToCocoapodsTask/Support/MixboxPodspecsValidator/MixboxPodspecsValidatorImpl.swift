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
    
    private let sandboxRepoName: String
    
    public init(
        repoRootProvider: RepoRootProvider,
        listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider,
        cocoapodCacheClean: CocoapodCacheClean,
        cocoapodsRepoAdd: CocoapodsRepoAdd,
        cocoapodsRepoPush: CocoapodsRepoPush,
        environmentProvider: EnvironmentProvider)
    {
        self.repoRootProvider = repoRootProvider
        self.listOfPodspecsToPushProvider = listOfPodspecsToPushProvider
        self.cocoapodCacheClean = cocoapodCacheClean
        self.cocoapodsRepoAdd = cocoapodsRepoAdd
        self.cocoapodsRepoPush = cocoapodsRepoPush
        self.environmentProvider = environmentProvider
        
        self.sandboxRepoName = "MixboxSandboxRepo-\(UUID().uuidString)"
    }
    
    public func validateMixboxPodspecs() throws {
        try cleanUpState()
        try pushPodspecsToSandboxRepo()
    }
    
    private func cleanUpState() throws {
        try cocoapodCacheClean.clean(target: .all)
        
        let fileManager = FileManager()
        let home = try environmentProvider.environment["HOME"].unwrapOrThrow()
        
        try fileManager.removeItem(atPath: "\(home)/Library/Caches/CocoaPods/Pods")
        try fileManager.removeItem(atPath: "\(home)/Library/Developer/Xcode/DerivedData/")
        try fileManager.removeItem(atPath: "\(home)/.cocoapods/repos/\(sandboxRepoName)")
    }
    
    private func pushPodspecsToSandboxRepo() throws {
        let repoRootPath = try repoRootProvider.repoRootPath()
        
        try cocoapodsRepoAdd.add(
            repoName: sandboxRepoName,
            url: repoRootPath
        )
        
        let listOfPodspecsToPush = try listOfPodspecsToPushProvider.listOfPodspecsToPush()
        
        try listOfPodspecsToPush.forEach { podspecName in
            try cocoapodsRepoPush.push(
                repoName: try repoRootProvider.repoRootPath(),
                pathToPodspec: repoRootPath.appending(
                    pathComponent: "\(podspecName).podspec"
                ),
                verbose: true,
                localOnly: true,
                allowWarnings: true,
                skipImportValidation: true,
                skipTests: true
            )
        }
    }
}
