import Destinations

public protocol GrayBoxTestRunner {
    func runTests(
        xctestBundle: String,
        appPath: String,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration])
        throws
}
