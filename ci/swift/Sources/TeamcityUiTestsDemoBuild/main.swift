import BuildDsl
import CheckDemoTask

BuildDsl.teamcity.main { di in
    try CheckDemoTask(
        bashExecutor: di.resolve(),
        iosProjectBuilder: di.resolve(),
        environmentProvider: di.resolve(),
        mixboxTestDestinationProvider: di.resolve(),
        bundlerCommandGenerator: di.resolve()
    )
}
