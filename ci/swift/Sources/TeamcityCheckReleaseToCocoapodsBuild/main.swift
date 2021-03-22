import BuildDsl
import SingletonHell
import CheckReleaseToCocoapodsTask
import Releases
import Foundation
import CiFoundation
import Destinations

BuildDsl.teamcity.main { di in
    try CheckReleaseToCocoapodsTask(
        headCommitHashProvider: di.resolve(),
        nextReleaseVersionProvider: di.resolve(),
        gitTagAdder: di.resolve(),
        gitTagDeleter: di.resolve(),
        mixboxPodspecsValidator: di.resolve(),
        mixboxReleaseSettingsProvider: di.resolve()
    )
}
