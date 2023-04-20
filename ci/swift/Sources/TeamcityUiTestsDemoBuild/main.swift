import BuildDsl
import CheckDemoTask
import Tasks
import DI

public final class TeamcityUiTestsDemoBuild: TeamcityBuild {
    public func task(di: DependencyResolver) throws -> LocalTask  {
        try CheckDemoTask(
            bashExecutor: di.resolve(),
            iosProjectBuilder: di.resolve(),
            environmentProvider: di.resolve(),
            mixboxTestDestinationProvider: di.resolve(),
            bundlerBashCommandGenerator: di.resolve(),
            bashEscapedCommandMaker: di.resolve()
        )
    }
}

BuildRunner.run(
    build: TeamcityUiTestsDemoBuild()
)
