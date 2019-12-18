import MixboxUiTestsFoundation

class AlwaysTrueMatcherTests: BaseMatcherTests {
    func test___match___matches___always() {
        assertMatches(
            matcher: AlwaysTrueMatcher()
        )
    }
    
    func test___description___is_correct() {
        assertDescriptionIsCorrect(
            matcher: AlwaysTrueMatcher(),
            description: "Всегда истинно"
        )
    }
}
