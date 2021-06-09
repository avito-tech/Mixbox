import BuildDsl
import SingletonHell
import ReleaseToCocoapodsTask
import Releases
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    try ReleaseToCocoapodsTask(
        headCommitHashProvider: di.resolve(),
        nextReleaseVersionProvider: di.resolve(),
        beforeReleaseTagsSetter: di.resolve(),
        mixboxPodspecsValidator: di.resolve(),
        mixboxPodspecsPusher: di.resolve(),
        mixboxReleaseSettingsProvider: di.resolve(),
        environmentProvider: di.resolve(),
        afterReleaseTagsSetterForExistingReleaseProvider: di.resolve(),
        currentReleaseVersionProvider: di.resolve()
    )
}
