import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

extension BaseTestCase {
    func assert<T>(
        value: T,
        matches matcher: Matcher<T>,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        let result = matcher.match(value: value)
        
        switch result {
        case .match:
            break
        case .mismatch(let mismatchResult):
            XCTFail(mismatchResult.mismatchDescription, file: file, line: line)
        }
    }
    
    func assert(
        logsAndFailures: LogsAndFailures,
        file: StaticString = #filePath,
        line: UInt = #line,
        matches buildMatcher: (LogsAndFailuresMatcherBuilder) -> (Matcher<LogsAndFailures>))
    {
        assert(
            value: logsAndFailures,
            matches: buildMatcher(LogsAndFailuresMatcherBuilder())
        )
    }
}
