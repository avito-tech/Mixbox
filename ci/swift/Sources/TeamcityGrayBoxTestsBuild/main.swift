import BuildDsl
import RunGrayBoxTestsTask
import Tasks
import DI

public final class TeamcityGrayBoxTestsBuild: TeamcityBuild {
    public func task(di: DependencyResolver) throws -> LocalTask  {
        try RunGrayBoxTestsTask(
            testsTaskRunner: di.resolve()
        )
    }
}

BuildRunner.run(
    build: TeamcityGrayBoxTestsBuild()
)
