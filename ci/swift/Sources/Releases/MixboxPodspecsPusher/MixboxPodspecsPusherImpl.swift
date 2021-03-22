import Cocoapods
import Git
import Extensions

public final class MixboxPodspecsPusherImpl: MixboxPodspecsPusher {
    private let listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider
    private let cocoapodsTrunkPush: CocoapodsTrunkPush
    private let repoRootProvider: RepoRootProvider
    
    public init(
        listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider,
        cocoapodsTrunkPush: CocoapodsTrunkPush,
        repoRootProvider: RepoRootProvider)
    {
        self.listOfPodspecsToPushProvider = listOfPodspecsToPushProvider
        self.cocoapodsTrunkPush = cocoapodsTrunkPush
        self.repoRootProvider = repoRootProvider
    }
    
    public func pushMixboxPodspecs() throws {
        let repoRoot = try repoRootProvider.repoRootPath()
        
        try listOfPodspecsToPushProvider.listOfPodspecsToPush().forEach { podspecName in
            try cocoapodsTrunkPush.push(
                pathToPodspec: repoRoot.appending(pathComponent: "\(podspecName).podspec"),
                allowWarnings: true,
                skipImportValidation: true,
                skipTests: true,
                synchronous: true
            )
        }
    }
}
