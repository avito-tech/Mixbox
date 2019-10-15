import BuildDsl
import CheckDemoTask
import Cocoapods
import Bundler

BuildDsl.travis.main(
    diOverrides: { container in
        // TODO: Test with different cocoapods versions. I don't know which we support.
        // Note: Builds on travis fails if cocoapods version is 1.5.3 and Xcode is not 10.2.1 (10.1 or 10).
        container.register(type: GemfileLocationProvider.self) {
            GemfileLocationProviderImpl(
                repoRootProvider: try container.resolve(),
                gemfileBasename: "Gemfile_cocoapods_1_7_0"
            )
        }
    },
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
