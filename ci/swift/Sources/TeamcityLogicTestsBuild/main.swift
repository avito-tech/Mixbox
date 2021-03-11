import BuildDsl
import RunUnitTestsTask

BuildDsl.teamcity.main { di in
    try RunUnitTestsTask(
        bashExecutor: di.resolve(),
        iosProjectBuilder: di.resolve(),
        mixboxTestDestinationProvider: di.resolve(),
        environmentProvider: di.resolve(),
        bundlerBashCommandGenerator: di.resolve(),
        bashEscapedCommandMaker: di.resolve()
    )
}
