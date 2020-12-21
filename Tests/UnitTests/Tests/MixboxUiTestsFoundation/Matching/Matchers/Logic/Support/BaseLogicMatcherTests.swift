import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

// TODO: Check attachments
class BaseLogicMatcherTests: BaseMatcherTests {
    let anyValue: Int = 1
    
    func assertMatches(
        matcher: Matcher<Int>,
        file: StaticString = #file,
        line: UInt = #line)
    {
        assertMatches(
            matcher: matcher,
            value: anyValue,
            file: file,
            line: line
        )
    }
    
    func assertMismatches(
        matcher: Matcher<Int>,
        percentageOfMatching: Double = 0,
        description: String? = nil,
        file: StaticString = #file,
        line: UInt = #line)
    {
        assertMismatches(
            matcher: matcher,
            value: anyValue,
            percentageOfMatching: percentageOfMatching,
            description: description,
            file: file,
            line: line
        )
    }
    
    func assertDescriptionIsCorrect(
        matcher: Matcher<Int>,
        description: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        assertDescriptionIsCorrect(
            matcher: matcher,
            value: anyValue,
            description: description,
            file: file,
            line: line
        )
    }
}
