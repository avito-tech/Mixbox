import MixboxUiTestsFoundation
import MixboxTestsFoundation

class NotMatcherTests: BaseLogicMatcherTests {
    func test___match___matches___if_nested_matcher_mismatches() {
        assertMatches(
            matcher: NotMatcher(AlwaysFalseMatcher())
        )
    }
    
    func test___match___mismatches___if_nested_matcher_matches() {
        assertMismatches(
            matcher: NotMatcher(AlwaysTrueMatcher())
        )
    }
    
    func test___description___is_correct() {
        assertDescriptionIsCorrect(
            matcher: NotMatcher(AlwaysFalseMatcher()),
            description:
            """
            not {
                Always false
            }
            """
        )
    }
}
