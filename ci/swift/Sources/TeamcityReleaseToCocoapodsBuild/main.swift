import BuildDsl
import SingletonHell
import ReleaseToCocoapodsTask
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    let listOfPodspecsToPushProvider = try ListOfPodspecsToPushProviderImpl(
        bundledProcessExecutor: di.resolve(),
        repoRootProvider: di.resolve()
    )
    
    return try ReleaseToCocoapodsTask(
        headCommitHashProvider: di.resolve(),
        nextReleaseVersionProvider: NextReleaseVersionProviderImpl(
            gitTagsProvider: di.resolve(),
            gitRevListProvider: di.resolve(),
            headCommitHashProvider: di.resolve()
        ),
        beforeReleaseTagsSetter: BeforeReleaseTagsSetterImpl(
            gitTagAdder: di.resolve()
        ),
        podspecsPatcher: PodspecsPatcherImpl(
            repoRootProvider: di.resolve()
        ),
        mixboxPodspecsValidator: MixboxPodspecsValidatorImpl(
            repoRootProvider: di.resolve(),
            listOfPodspecsToPushProvider: listOfPodspecsToPushProvider,
            cocoapodCacheClean: di.resolve(),
            cocoapodsRepoAdd: di.resolve(),
            cocoapodsRepoPush: di.resolve(),
            environmentProvider: di.resolve()
        ),
        mixboxPodspecsPusher: MixboxPodspecsPusherImpl(
            listOfPodspecsToPushProvider: listOfPodspecsToPushProvider,
            cocoapodsTrunkPush: di.resolve(),
            repoRootProvider: di.resolve()
        )
    )
}
