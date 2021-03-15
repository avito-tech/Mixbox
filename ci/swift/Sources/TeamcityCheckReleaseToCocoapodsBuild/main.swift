import BuildDsl
import SingletonHell
import CheckReleaseToCocoapodsTask
import Releases
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    let listOfPodspecsToPushProvider = try ListOfPodspecsToPushProviderImpl(
        bundledProcessExecutor: di.resolve(),
        repoRootProvider: di.resolve()
    )
    
    return try CheckReleaseToCocoapodsTask(
        headCommitHashProvider: di.resolve(),
        nextReleaseVersionProvider: NextReleaseVersionProviderImpl(
            gitTagsProvider: di.resolve(),
            gitRevListProvider: di.resolve(),
            headCommitHashProvider: di.resolve()
        ),
        gitTagAdder: di.resolve(),
        gitTagDeleter: di.resolve(),
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
        mixboxReleaseSettingsProvider: MixboxReleaseSettingsProviderImpl()
    )
}
