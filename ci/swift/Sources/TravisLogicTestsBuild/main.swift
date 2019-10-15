import BuildDsl
import RunUnitTestsTask

BuildDsl.travis.main { di in
    try RunUnitTestsTask(
        bashExecutor: di.resolve(),
        iosProjectBuilder: di.resolve(),
        mixboxTestDestinationProvider: di.resolve(),
        environmentProvider: di.resolve(),
        bundlerCommandGenerator: di.resolve()
    )
}
