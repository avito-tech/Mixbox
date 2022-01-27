import Cocoapods
import Git
import EmceeExtensions
import CiFoundation

public final class MixboxPodspecsPusherImpl: MixboxPodspecsPusher {
    private let listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider
    private let cocoapodsTrunkPush: CocoapodsTrunkPush
    private let repoRootProvider: RepoRootProvider
    private let retrier: Retrier
    private let cocoapodsTrunkInfo: CocoapodsTrunkInfo
    
    public init(
        listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider,
        cocoapodsTrunkPush: CocoapodsTrunkPush,
        repoRootProvider: RepoRootProvider,
        retrier: Retrier,
        cocoapodsTrunkInfo: CocoapodsTrunkInfo)
    {
        self.listOfPodspecsToPushProvider = listOfPodspecsToPushProvider
        self.cocoapodsTrunkPush = cocoapodsTrunkPush
        self.repoRootProvider = repoRootProvider
        self.retrier = retrier
        self.cocoapodsTrunkInfo = cocoapodsTrunkInfo
    }
    
    public func pushMixboxPodspecs() throws {
        try listOfPodspecsToPushProvider.listOfPodspecsToPush().forEach { podspec in
            // Sometimes there is this error:
            // ```
            // [!] An internal server error occurred. Please check for any known status issues at https://twitter.com/CocoaPods and try again later.'
            // ```
            try retrier.retry(timeouts: [30, 60, 120, 300]) {
                // Afaik there are problems with synchronization in cocoapods,
                // so we put check if pod is realeased inside retry block, not outside of it.
                // `Push` can be syncronized with `synchronous` option, but there is no such option in
                // trunk info. See: https://github.com/CocoaPods/CocoaPods/issues/9497
                // I am not sure if it really works better, this is just a precaution.
                if try shouldPush(podspec: podspec) {
                    try push(podspec: podspec)
                }
            }
        }
    }
    
    private func shouldPush(podspec: JsonPodspec) throws -> Bool {
        return !(try shouldSkip(podspec: podspec))
    }
    
    private func shouldSkip(podspec: JsonPodspec) throws -> Bool {
        let info = try cocoapodsTrunkInfo.info(podName: podspec.name)
        
        switch info {
        case .found(let info):
            return info.versions.contains {
                // Check if podspec with this version is already released
                $0.versionString == podspec.version
            }
        case .notFound:
            return false
        }
    }
    
    private func push(podspec: JsonPodspec) throws {
        let repoRoot = try repoRootProvider.repoRootPath()
        
        try cocoapodsTrunkPush.push(
            pathToPodspec: repoRoot.appending(pathComponent: "\(podspec.name).podspec"),
            allowWarnings: true,
            skipImportValidation: true,
            skipTests: true,
            synchronous: true
        )
    }
}
