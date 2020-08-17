import XCTest
import MixboxFoundation
import MixboxTestsFoundation
import MixboxBuiltinDi
import TestsIpc

// TODO: Replace XCTestCase with TestCase for every test.
class TestCase: BaseTestCase {
    override func makeDependencies() -> TestFailingDependencyResolver {
        TestCaseDi.make(
            dependencyCollectionRegisterer: WhiteBoxTestCaseDependencies(),
            dependencyInjectionFactory: BuiltinDependencyInjectionFactory(),
            performanceLogger: NoopPerformanceLogger()
        )
    }
}
