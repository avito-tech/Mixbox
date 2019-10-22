import BuildDsl
import CheckDemoTask
import Cocoapods
import Bundler

BuildDsl.travis.main(
    makeLocalTask: { di in
        try CheckDemoTask(
            bashExecutor: di.resolve(),
            iosProjectBuilder: di.resolve(),
            environmentProvider: di.resolve(),
            mixboxTestDestinationProvider: di.resolve(),
            bundlerCommandGenerator: di.resolve()
        )
    }
)
