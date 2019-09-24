import Destinations

public protocol BlackBoxTestRunner {
    func runTests(
        xctestBundle: String,
        runnerPath: String,
        appPath: String,
        additionalAppPaths: [String],
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration])
        throws
}
