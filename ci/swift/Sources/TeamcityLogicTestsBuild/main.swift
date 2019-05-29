import BuildDsl
import RunUnitTestsTask

BuildDsl.teamcity.main { di in
    try RunUnitTestsTask(
        bashExecutor: di.resolve()
    )
}
