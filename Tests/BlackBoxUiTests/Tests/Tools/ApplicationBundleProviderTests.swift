import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation

final class ApplicationBundleProviderTests: TestCase {
    func test() throws {
        // TODO: ¯\_(ツ)_/¯ Fix
        if environmentProvider.environment["MIXBOX_CI_USES_FBXCTEST"] == "true" {
            return
        }
        
        openScreen(name: "ApplicationBundleProviderTestsView")
        pageObjects.screen.bundlePath.assertIsDisplayed()
        
        let application = XCUIApplication()
        
        let installedApplicationBundleProvider = InstalledApplicationBundleProvider(
            application: application,
            currentSimulatorFileSystemRootProvider: CurrentApplicationCurrentSimulatorFileSystemRootProvider()
        )
        
        let installedApplicationBundle = try installedApplicationBundleProvider
            .applicationBundle()
        
        let builtApplicationBundle = try BuiltApplicationBundleProvider(application: application)
            .applicationBundle()
        
        // Test if they are proper bundles
        XCTAssertEqual(installedApplicationBundle.bundleIdentifier, "mixbox.Tests.TestedApp")
        XCTAssertEqual(builtApplicationBundle.bundleIdentifier, "mixbox.Tests.TestedApp")
        
        // Test path of installed bundle
        pageObjects.screen.bundlePath.withoutTimeout.assertHasText(
            installedApplicationBundle.bundlePath.mb_resolvingSymlinksInPath
        )
        
        // Test path of built bundle (kind of)
        XCTAssertNotEqual(builtApplicationBundle.bundlePath, installedApplicationBundle.bundlePath)
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    var bundlePath: LabelElement {
        return element("bundlePath") { $0.id == "bundlePath" }
    }
}

private extension PageObjects {
    var screen: Screen {
        return pageObject()
    }
}
