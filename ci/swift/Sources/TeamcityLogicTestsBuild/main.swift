import BuildDsl
import RunUnitTestsTask
import Tasks
import DI

public final class TeamcityLogicTestsBuild: TeamcityBuild {
    public func task(di: DependencyResolver) throws -> LocalTask  {
        try RunUnitTestsTask(
            testsTaskRunner: di.resolve()
        )
    }
}

BuildRunner.run(
    build: TeamcityLogicTestsBuild()
)
