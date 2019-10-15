import BuildDsl
import CheckIpcDemoTask

BuildDsl.travis.main { di in
    try CheckIpcDemoTask(
        bashExecutor: di.resolve(),
        macosProjectBuilder: di.resolve()
    )
}
