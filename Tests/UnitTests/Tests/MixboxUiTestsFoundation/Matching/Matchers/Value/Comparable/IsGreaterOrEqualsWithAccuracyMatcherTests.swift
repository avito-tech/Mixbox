import MixboxTestsFoundation

class IsGreaterOrEqualsWithAccuracyMatcherTests: BaseMatcherTests {
    func test___match___mismatches___if_value_is_less() {
        assertMismatches(
            matcher: matcher(value: 2, accuracy: 0.1),
            value: 1,
            description:
            """
            value (with accuracy ±0.1) is not greater than or equal to '2.0', actual value: '1.0'
            """
        )
    }
    
    func test___match___matches___if_value_is_less_but_within_accuracy() {
        assertMatches(
            matcher: matcher(value: 2, accuracy: 0.1),
            value: 1.9
        )
    }
    
    func test___match___matches___if_value_is_equal_and_accuracy_is_greater_than_zero() {
        assertMatches(
            matcher: matcher(value: 2, accuracy: 0.1),
            value: 2
        )
    }
    
    func test___match___matches___if_value_is_equal_and_accuracy_is_zero() {
        assertMatches(
            matcher: matcher(value: 2, accuracy: 0),
            value: 2
        )
    }
    
    func test___match___mismatches___is_less_than_zero() {
        assertMismatches(
            matcher: matcher(value: generator.generate(), accuracy: -1),
            value: generator.generate(),
            description:
            """
            matcher is invalid, accuracy is less than zero: -1.0
            """
        )
    }
    
    func test___match___matches___if_value_is_greater() {
        assertMatches(
            matcher: matcher(value: 2, accuracy: 0.1),
            value: 3
        )
    }
    
    private func matcher(value: Double, accuracy: Double) -> Matcher<Double> {
        IsGreaterOrEqualsWithAccuracyMatcher(value, accuracy: accuracy)
    }
}
