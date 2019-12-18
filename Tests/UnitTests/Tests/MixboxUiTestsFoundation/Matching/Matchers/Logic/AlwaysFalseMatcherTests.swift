import MixboxUiTestsFoundation
import XCTest

class AlwaysFalseMatcherTests: BaseMatcherTests {
    func test___match___mismatches___always() {
        assertMismatches(
            matcher: AlwaysFalseMatcher(),
            percentageOfMatching: 0,
            description: "Всегда ложно"
        )
    }
    
    func test___description___is_correct() {
        assertDescriptionIsCorrect(
            matcher: AlwaysFalseMatcher(),
            description: "Всегда ложно"
        )
    }
}
