import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation

final class ApplicationBundleProviderTests: TestCase {
    func test() throws {
        openScreen(name: "ApplicationBundleProviderTestsView")
        pageObjects.screen.bundlePath.assert.isDisplayed()
        
        let application = XCUIApplication()
        
        let installedApplicationBundle = try InstalledApplicationBundleProvider(application: application)
            .applicationBundle()
        
        let builtApplicationBundle = try BuiltApplicationBundleProvider(application: application)
            .applicationBundle()
        
        // Test if they are proper bundles
        XCTAssertEqual(installedApplicationBundle.bundleIdentifier, "mixbox.XcuiTests.app")
        XCTAssertEqual(builtApplicationBundle.bundleIdentifier, "mixbox.XcuiTests.app")
        
        // Test path of installed bundle
        pageObjects.screen.bundlePath.withoutTimeout.assert.hasText(installedApplicationBundle.bundlePath)
        
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
