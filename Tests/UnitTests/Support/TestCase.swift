import XCTest
import MixboxFoundation
import Dip

// TODO: Replace XCTestCase with TestCase for every test.
class TestCase: XCTestCase {
    override class func setUp() {
        // To suppress these logs:
        //
        // ```
        // No definition registered for type: Generator<Author>, arguments: (), tag: nil.
        // Check the tag, type you try to resolve, number, order and types of runtime arguments passed to `resolve()` and match them with registered factories for type Generator<Author>.
        // ```
        //
        // For example, if we try to resolve dependency from multiple resolvers (e.g. fallbacks, mocks, etc),
        // it is totally okay if some dependency is not resolved. There is no need to write logs in stdout via a singleton.
        //
        // TODO: Get rid of Dip. Usage of Dip in tests is limiting. And we don't use it fully anyway.
        //
        Dip.logLevel = .None
        super.setUp()
    }
}
