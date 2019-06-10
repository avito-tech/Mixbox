import BuildDsl
import CheckDemoTask

BuildDsl.travis.main { di in
    try CheckDemoTask(
        bashExecutor: di.resolve(),
        // TODO: Test with different cocoapods versions. I don't know which we support.
        // Note: Builds on travis fails if cocoapods version is 1.5.3 and Xcode is not 10.2.1 (10.1 or 10).
        cocoapodsVersion: "1.7.0"
    )
}
