import MixboxTestsFoundation

class IsLessOrEqualsMatcherTests: BaseMatcherTests {
    func test___match___matches___if_value_is_less() {
        assertMatches(
            matcher: matcher(value: 2),
            value: 1
        )
    }
    
    func test___match___matches___if_value_is_equal() {
        assertMatches(
            matcher: matcher(value: 2),
            value: 2
        )
    }
    
    func test___match___mismatches___if_value_is_greater() {
        assertMismatches(
            matcher: matcher(value: 2),
            value: 3,
            description:
            """
            value is not greater than '2.0', actual value: '3.0'
            """
        )
    }
    
    private func matcher(value: Double) -> Matcher<Double> {
        IsLessOrEqualsMatcher(value)
    }
}
