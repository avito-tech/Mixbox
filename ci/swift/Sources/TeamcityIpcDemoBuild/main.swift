import BuildDsl
import CheckIpcDemoTask
import Tasks
import DI

public final class TeamcityIpcDemoBuild: TeamcityBuild {
    public func task(di: DependencyResolver) throws -> LocalTask  {
        try CheckIpcDemoTask(
            bashExecutor: di.resolve(),
            macosProjectBuilder: di.resolve()
        )
    }
}

BuildRunner.run(
    build: TeamcityIpcDemoBuild()
)
