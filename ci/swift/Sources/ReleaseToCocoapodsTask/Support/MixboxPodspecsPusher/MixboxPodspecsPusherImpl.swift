import Cocoapods
import Git

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
        try listOfPodspecsToPushProvider.listOfPodspecsToPush().forEach { podspecName in
            try cocoapodsTrunkPush.push(
                pathToPodspec: try pathToPodspec(
                    podspecName: podspecName
                ),
                allowWarnings: true,
                skipImportValidation: true,
                skipTests: true
            )
        }
    }
    
    private func pathToPodspec(podspecName: String) throws -> String {
        try repoRootProvider.repoRootPath().appending(pathComponent: "\(podspecName)")
    }
}
