import BuildDsl
import SingletonHell
import ReleaseToCocoapodsTask
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    try ReleaseToCocoapodsTask(
        headCommitHashProvider: di.resolve(),
        nextReleaseVersionProvider: NextReleaseVersionProviderImpl(
            gitTagsProvider: di.resolve(),
            gitRevListProvider: di.resolve(),
            headCommitHashProvider: di.resolve()
        ),
        beforeReleaseTagsSetter: BeforeReleaseTagsSetterImpl(
            gitTagAdder: di.resolve()
        )
    )
}
