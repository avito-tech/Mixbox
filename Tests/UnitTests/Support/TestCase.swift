import XCTest
import MixboxFoundation
import MixboxTestsFoundation
import MixboxBuiltinDi
import TestsIpc

// TODO: Replace XCTestCase with TestCase for every test.
class TestCase: BaseTestCase {
    var testType: TestType {
        .whiteBox
    }
    
    override func dependencyInjectionConfiguration() -> DependencyInjectionConfiguration {
        DependencyInjectionConfiguration(
            dependencyCollectionRegisterer: WhiteBoxTestCaseDependencies()
        )
    }
}
