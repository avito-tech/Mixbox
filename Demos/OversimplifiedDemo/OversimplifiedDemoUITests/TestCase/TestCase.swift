import XCTest

class TestCase: XCTestCase {
    private let testCaseDependencies = TestCaseDependencies()
    
    var pageObjects: PageObjects {
        return testCaseDependencies.pageObjects
    }
    
    func launch() {
        testCaseDependencies.application.launchEnvironment["MIXBOX_ENABLE_IN_APP_SERVICES"] = "true"
        testCaseDependencies.application.launchTunnel()
    }
}
