import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation

open class BaseTestCase: XCTestCase {
    public var pageObjects: PageObjects {
       return dependencies.resolve()
    }
    
    public private(set) lazy var dependencies: TestFailingDependencyResolver = makeDependencies()
    
    open func makeDependencies() -> TestFailingDependencyResolver {
        UnavoidableFailure.fail("You should override makeDependencies() in your test case class")
    }
}
