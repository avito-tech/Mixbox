import Cocoapods
import Git
import Extensions
import CiFoundation

public final class MixboxPodspecsPusherImpl: MixboxPodspecsPusher {
    private let listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider
    private let cocoapodsTrunkPush: CocoapodsTrunkPush
    private let repoRootProvider: RepoRootProvider
    private let retrier: Retrier
    
    public init(
        listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider,
        cocoapodsTrunkPush: CocoapodsTrunkPush,
        repoRootProvider: RepoRootProvider,
        retrier: Retrier)
    {
        self.listOfPodspecsToPushProvider = listOfPodspecsToPushProvider
        self.cocoapodsTrunkPush = cocoapodsTrunkPush
        self.repoRootProvider = repoRootProvider
        self.retrier = retrier
    }
    
    public func pushMixboxPodspecs() throws {
        let repoRoot = try repoRootProvider.repoRootPath()
        
        try listOfPodspecsToPushProvider.listOfPodspecsToPush().forEach { podspecName in
            // Sometimes there is this error:
            // ```
            // [!] An internal server error occurred. Please check for any known status issues at https://twitter.com/CocoaPods and try again later.'
            // ```
            
            try retrier.retry(timeouts: [30, 60, 120, 300]) {
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
}
