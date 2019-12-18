import MixboxUiTestsFoundation

class OrMatcherTests: BaseMatcherTests {
    func test___match___matches___if_at_least_one_of_nested_matchers_matches() {
        assertMatches(
            matcher: OrMatcher([AlwaysTrueMatcher()])
        )
        
        assertMatches(
            matcher: OrMatcher([AlwaysFalseMatcher(), AlwaysTrueMatcher()])
        )
        
        assertMatches(
            matcher: OrMatcher([AlwaysTrueMatcher(), AlwaysFalseMatcher()])
        )
    }
    
    func test___match___mismatches___if_all_nested_matchers_mismatches() {
        assertMismatches(
            matcher: OrMatcher([AlwaysFalseMatcher()])
        )
    }
    
    func test___match___mismatches___if_there_are_no_nested_matchers() {
        assertMismatches(
            matcher: OrMatcher([])
        )
    }
    
    func test___match___mismatches_with_percentageOfMatching_equal_to_maximum_of_percentageOfMatching_of_nested_matchers() {
        let point10Matcher: Matcher<Int> = AndMatcher(
            Array(repeating: AlwaysTrueMatcher(), count: 1)
                + Array(repeating: AlwaysFalseMatcher(), count: 9)
        )
        let point25Matcher: Matcher<Int> = AndMatcher(
            Array(repeating: AlwaysTrueMatcher(), count: 1)
                + Array(repeating: AlwaysFalseMatcher(), count: 3)
        )
        
        assertMismatches(
            matcher: OrMatcher([point10Matcher, point25Matcher]),
            percentageOfMatching: 0.25
        )
        
        assertMismatches(
            matcher: OrMatcher([point25Matcher, point10Matcher]),
            percentageOfMatching: 0.25
        )
    }
    
    func test___description___is_correct() {
        assertDescriptionIsCorrect(
            matcher: OrMatcher([AlwaysFalseMatcher()]),
            description:
            """
            Любое из [
                Всегда ложно
            ]
            """
        )
    }
}
