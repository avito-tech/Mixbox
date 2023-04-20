import BuildDsl
import CheckReleaseToCocoapodsTask
import Tasks
import DI

public final class TeamcityCheckReleaseToCocoapodsBuild: TeamcityBuild {
    public func task(di: DependencyResolver) throws -> LocalTask  {
        try CheckReleaseToCocoapodsTask(
            headCommitHashProvider: di.resolve(),
            nextReleaseVersionProvider: di.resolve(),
            gitTagAdder: di.resolve(),
            gitTagDeleter: di.resolve(),
            mixboxPodspecsValidator: di.resolve(),
            mixboxReleaseSettingsProvider: di.resolve()
        )
    }
}

BuildRunner.run(
    build: TeamcityCheckReleaseToCocoapodsBuild()
)
