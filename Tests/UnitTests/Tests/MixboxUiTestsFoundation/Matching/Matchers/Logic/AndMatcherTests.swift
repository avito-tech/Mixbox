import MixboxUiTestsFoundation
import MixboxTestsFoundation

class AndMatcherTests: BaseLogicMatcherTests {
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
            All of [
                Always false
            ]
            """
        )
    }
    
    func test___match___does_not_use_matcher_after_first_failure__if_skipMatchingWhenMatchOrMismatchIsDetected_is_true() {
        let matcher = AndMatcher<Int>(
            [
                AlwaysTrueMatcher(),
                AlwaysFalseMatcher(),
                AlwaysTrueMatcher(),
                TestFailingMatcher()
            ],
            skipMatchingWhenMatchOrMismatchIsDetected: true
        )
        
        let actualResult = matcher.match(value: 0)
        
        let expectedResult = MatchingResult.mismatch(
            LazyMismatchResult(
                percentageOfMatching: 0.25, // 1 out of 4, skipped matchers are treated as not matching
                mismatchDescriptionFactory: {
                    """
                    All of [
                        (v) Always true
                        (x) Always false
                        (x) Skipped due to `skipMatchingWhenMatchOrMismatchIsDetected` == true and matching failure
                        (x) Skipped due to `skipMatchingWhenMatchOrMismatchIsDetected` == true and matching failure
                    ]
                    """
                },
                attachmentsFactory: { [] }
            )
        )
        
        XCTAssertEqual(actualResult, expectedResult)
    }
}
