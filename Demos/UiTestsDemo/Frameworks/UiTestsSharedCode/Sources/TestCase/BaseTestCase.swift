import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation

open class BaseTestCase: XCTestCase {
    public var pageObjects: PageObjects {
       return dependencies.resolve()
    }
    
    public private(set) lazy var dependencies: TestCaseDependenciesResolver = makeDependencies()
    
    open func makeDependencies() -> TestCaseDependenciesResolver {
        UnavoidableFailure.fail("You should override makeDependencies() in your test case class")
    }
}
