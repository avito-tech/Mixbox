import MixboxTestsFoundation

// TODO: Test descriptions
class ArrayEqualsMatcherTests: BaseMatcherTests {
    func test___match___matches___if_matcher_and_matched_arrays_are_empty() {
        assertMatches(
            matcher: ArrayEqualsMatcher(matchers: []),
            value: []
        )
    }
    
    func test___match___matches___if_all_nested_matchers_matches() {
        assertMatches(
            matcher: ArrayEqualsMatcher(matchers: [AlwaysTrueMatcher(), AlwaysTrueMatcher()]),
            value: [1, 2]
        )
    }
    
    func test___match___mismatches___if_some_of_nested_matchers_mismatches() {
        assertMismatches(
            matcher: ArrayEqualsMatcher(matchers: [AlwaysTrueMatcher(), AlwaysFalseMatcher()]),
            value: [1, 2],
            percentageOfMatching: 0.5
        )
    }
    
    func test___match___mismatches___if_matcher_and_matched_arrays_are_of_different_size___0() {
        assertMismatches(
            matcher: ArrayEqualsMatcher(matchers: [AlwaysTrueMatcher()]),
            value: [],
            percentageOfMatching: 0
        )
    }
    
    func test___match___mismatches___if_matcher_and_matched_arrays_are_of_different_size___1() {
        assertMismatches(
            matcher: ArrayEqualsMatcher(matchers: []),
            value: [1]
        )
    }
}
