import BuildDsl
import RunUnitTestsTask
import Tasks
import DI

public final class TravisLogicTestsBuild: TravisBuild {
    public func task(di: DependencyResolver) throws -> LocalTask  {
        try RunUnitTestsTask(
            testsTaskRunner: di.resolve()
        )
    }
}

BuildRunner.run(
    build: TravisLogicTestsBuild()
)
