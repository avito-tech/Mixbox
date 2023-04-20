import BuildDsl
import RunBlackBoxTestsTask
import Tasks
import DI

public final class TeamcityBlackBoxTestsBuild: TeamcityBuild {
    public func task(di: DependencyResolver) throws -> LocalTask  {
        try RunBlackBoxTestsTask(
            testsTaskRunner: di.resolve()
        )
    }
}

BuildRunner.run(
    build: TeamcityBlackBoxTestsBuild()
)
