import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

class AlwaysFalseMatcherTests: BaseLogicMatcherTests {
    func test___match___mismatches___always() {
        assertMismatches(
            matcher: AlwaysFalseMatcher(),
            percentageOfMatching: 0,
            description: "Always false"
        )
    }
    
    func test___description___is_correct() {
        assertDescriptionIsCorrect(
            matcher: AlwaysFalseMatcher(),
            description: "Always false"
        )
    }
}
