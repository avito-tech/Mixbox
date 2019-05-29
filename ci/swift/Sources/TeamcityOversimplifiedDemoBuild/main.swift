import BuildDsl
import CheckDemoTask

BuildDsl.teamcity.main { di in
    try CheckDemoTask(
        bashExecutor: di.resolve(),
        cocoapodsVersion: nil
    )
}

