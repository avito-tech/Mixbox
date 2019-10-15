import BuildDsl
import CheckIpcDemoTask

BuildDsl.teamcity.main { di in
    try CheckIpcDemoTask(
        bashExecutor: di.resolve(),
        macosProjectBuilder: di.resolve()
    )
}
