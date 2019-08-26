import MixboxUiTestsFoundation
import XCTest

class MatchersTests: BaseMatcherTests {
    private var anything: Int = 1
    
    func test_AlwaysFalseMatcher() {
        assertMismatches(
            matcher: AlwaysFalseMatcher(),
            value: anything
        )
    }
    
    func test_AlwaysTrueMatcher() {
        assertMatches(
            matcher: AlwaysTrueMatcher(),
            value: anything
        )
    }
    
    func test_AndMatcher() {
        assertMatches(
            matcher: AndMatcher([AlwaysTrueMatcher()]),
            value: anything
        )
        
        assertMismatches(
            matcher: AndMatcher([AlwaysFalseMatcher()]),
            value: anything
        )
        
        assertMismatches(
            matcher: AndMatcher([AlwaysFalseMatcher(), AlwaysTrueMatcher()]),
            value: anything,
            percentageOfMatching: 0.5
        )
        
        assertMismatches(
            matcher: AndMatcher([AlwaysTrueMatcher(), AlwaysFalseMatcher()]),
            value: anything,
            percentageOfMatching: 0.5
        )
        
        assertMismatches(
            matcher: AndMatcher([]),
            value: anything
        )
        
        let point10Matcher: Matcher<Int> = AndMatcher(
            Array(repeating: AlwaysTrueMatcher(), count: 1)
                + Array(repeating: AlwaysFalseMatcher(), count: 9)
        )
        
        assertMismatches(
            matcher: point10Matcher,
            value: anything,
            percentageOfMatching: 0.1
        )
        
        let point25Matcher: Matcher<Int> = AndMatcher(
            Array(repeating: AlwaysTrueMatcher(), count: 1)
                + Array(repeating: AlwaysFalseMatcher(), count: 3)
        )
        
        assertMismatches(
            matcher: point10Matcher,
            value: anything,
            percentageOfMatching: 0.1
        )
        
        assertMismatches(
            matcher: AndMatcher([point10Matcher, point25Matcher]),
            value: anything,
            percentageOfMatching: 0.175
        )
    }
    
    func test_OrMatcher() {
        assertMatches(
            matcher: OrMatcher([AlwaysTrueMatcher()]),
            value: anything
        )
        
        assertMismatches(
            matcher: OrMatcher([AlwaysFalseMatcher()]),
            value: anything
        )
        
        assertMatches(
            matcher: OrMatcher([AlwaysFalseMatcher(), AlwaysTrueMatcher()]),
            value: anything
        )
        
        assertMatches(
            matcher: OrMatcher([AlwaysTrueMatcher(), AlwaysFalseMatcher()]),
            value: anything
        )
        
        assertMismatches(
            matcher: OrMatcher([]),
            value: anything
        )
        
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
            value: anything,
            percentageOfMatching: 0.25
        )
        
        assertMismatches(
            matcher: OrMatcher([point25Matcher, point10Matcher]),
            value: anything,
            percentageOfMatching: 0.25
        )
    }
    
    func test_NotMatcher() {
        assertMismatches(
            matcher: NotMatcher(AlwaysTrueMatcher()),
            value: anything
        )
        
        assertMatches(
            matcher: NotMatcher(AlwaysFalseMatcher()),
            value: anything
        )
    }
}
