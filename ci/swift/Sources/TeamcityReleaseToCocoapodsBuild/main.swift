import BuildDsl
import ReleaseToCocoapodsTask
import Tasks
import DI

public final class TeamcityReleaseToCocoapodsBuild: TeamcityBuild {
    public func task(di: DependencyResolver) throws -> LocalTask  {
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
}

BuildRunner.run(
    build: TeamcityReleaseToCocoapodsBuild()
)
