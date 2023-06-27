import MixboxTestsFoundation

class IsGreaterOrEqualsMatcherTests: BaseMatcherTests {
    func test___match___mismatches___if_value_is_less() {
        assertMismatches(
            matcher: matcher(value: 2),
            value: 1,
            description:
            """
            value is not greater than '2.0', actual value: '1.0'
            """
        )
    }
    
    func test___match___matches___if_value_is_equal() {
        assertMatches(
            matcher: matcher(value: 2),
            value: 2
        )
    }
    
    func test___match___matches___if_value_is_greater() {
        assertMatches(
            matcher: matcher(value: 2),
            value: 3
        )
    }
    
    private func matcher(value: Double) -> Matcher<Double> {
        IsGreaterOrEqualsMatcher(value)
    }
}
