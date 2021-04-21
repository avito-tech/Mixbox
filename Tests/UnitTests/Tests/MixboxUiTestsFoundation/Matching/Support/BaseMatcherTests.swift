import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

// TODO: Check attachments
class BaseMatcherTests: XCTestCase {
    let matcherBuilder = ElementMatcherBuilderFactory.elementMatcherBuilder()
    
    func assertMatches(
        locator: ElementMatcherBuilderClosure,
        snapshot: ElementSnapshot,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        assertMatches(
            matcher: locator(ElementMatcherBuilderFactory.elementMatcherBuilder()),
            value: snapshot,
            file: file,
            line: line
        )
    }
    
    func assertMatches<T>(
        matcher: Matcher<T>,
        value: T,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        switch matcher.match(value: value) {
        case .match:
            break
        case let .mismatch(mismatchResult):
            XCTFail("""
                Expected: match
                Actual: mismatch
                Matcher: \(matcher.description)
                Value: \(value)
                PercentageOfMatching: \(mismatchResult.percentageOfMatching)
                MismatchDescription: \(mismatchResult.mismatchDescription)
                """,
                file: file,
                line: line
            )
        }
    }
    
    func assertMismatches(
        locator: ElementMatcherBuilderClosure,
        snapshot: ElementSnapshot,
        percentageOfMatching: Double = 0,
        description: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        assertMismatches(
            matcher: locator(ElementMatcherBuilderFactory.elementMatcherBuilder()),
            value: snapshot,
            percentageOfMatching: percentageOfMatching,
            description: description,
            file: file,
            line: line
        )
    }
    
    func assertMismatches<T>(
        matcher: Matcher<T>,
        value: T,
        percentageOfMatching: Double = 0,
        description: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        switch matcher.match(value: value) {
        case .match:
            XCTFail("""
                Expected: mismatch
                Actual: match
                Matcher: \(matcher.description)
                Value: \(value)
                """,
                file: file,
                line: line
            )
        case let .mismatch(mismatchResult):
            let actualPercentageOfMatching = mismatchResult.percentageOfMatching
            
            if percentageOfMatching != actualPercentageOfMatching {
                XCTFail("""
                    Expected percentageOfMatching: \(percentageOfMatching)
                    Actual: \(actualPercentageOfMatching)
                    Matcher: \(matcher.description)
                    Value: \(value)
                    """,
                    file: file,
                    line: line
                )
            }
            
            if let description = description {
                let actualDescription = mismatchResult.mismatchDescription
                
                if description != actualDescription {
                    XCTFail("""
                        Expected mismatchDescription: \(description)
                        Actual: \(actualDescription)
                        Matcher: \(matcher.description)
                        Value: \(value)
                        """,
                        file: file,
                        line: line
                    )
                }
            }
        }
    }
    
    func assertDescriptionIsCorrect<T>(
        matcher: Matcher<T>,
        value: T,
        description: String,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        XCTAssertEqual(
            matcher.description,
            description,
            file: file,
            line: line
        )
    }
}
