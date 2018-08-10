import XCTest

class TestCase: XCTestCase {
    private let testCaseDependencies = TestCaseDependencies()
    
    var pageObjects: PageObjects {
        return testCaseDependencies.pageObjects
    }
    
    func launch() {
        testCaseDependencies.application.launchTunnel()
    }
}
