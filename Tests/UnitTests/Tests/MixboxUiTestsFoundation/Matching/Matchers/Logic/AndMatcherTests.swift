import MixboxUiTestsFoundation

class AndMatcherTests: BaseMatcherTests {
    func test___match___matches___if_all_nested_matchers_matches() {
        assertMatches(
            matcher: AndMatcher([AlwaysTrueMatcher()])
        )
    }
    
    func test___match___mismatches___if_all_nested_matchers_mismatches() {
        assertMismatches(
            matcher: AndMatcher([AlwaysFalseMatcher()])
        )
    }

    func test___match___mismatches___if_there_are_no_nested_matchers() {
        assertMismatches(
            matcher: AndMatcher([])
        )
    }
    
    func test___match___mismatches_with_percentageOfMatching_equal_to_average_of_percentageOfMatching_of_nested_matchers() {
        assertMismatches(
            matcher: AndMatcher([AlwaysFalseMatcher(), AlwaysTrueMatcher()]),
            percentageOfMatching: 0.5
        )
        
        // Matchers are ordered differently, but should provider same result
        assertMismatches(
            matcher: AndMatcher([AlwaysTrueMatcher(), AlwaysFalseMatcher()]),
            percentageOfMatching: 0.5
        )
        
        // More complex cases
        let point10Matcher: Matcher<Int> = AndMatcher(
            Array(repeating: AlwaysTrueMatcher(), count: 1)
                + Array(repeating: AlwaysFalseMatcher(), count: 9)
        )
        
        assertMismatches(
            matcher: point10Matcher,
            percentageOfMatching: 0.1
        )
        
        let point25Matcher: Matcher<Int> = AndMatcher(
            Array(repeating: AlwaysTrueMatcher(), count: 1)
                + Array(repeating: AlwaysFalseMatcher(), count: 3)
        )
        
        assertMismatches(
            matcher: point10Matcher,
            percentageOfMatching: 0.1
        )
        
        assertMismatches(
            matcher: AndMatcher([point10Matcher, point25Matcher]),
            percentageOfMatching: 0.175
        )
    }
    
    func test___description___is_correct() {
        assertDescriptionIsCorrect(
            matcher: AndMatcher([AlwaysFalseMatcher()]),
            description:
            """
            Всё из [
                Всегда ложно
            ]
            """
        )
    }
}
