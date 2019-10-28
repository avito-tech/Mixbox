import XCTest
import MixboxUiTestsFoundation

protocol FailureGatherer: class {
    func gatherFailures<T>(body: () -> (T)) -> GatherFailuresResult<T>
}

// TODO: Remove singletons (XCTAssert)
extension FailureGatherer {
    func assertFails(
        fileOfThisAssertion: StaticString = #file,
        lineOfThisAssertion: UInt = #line,
        body: () -> ())
    {
        let failures = gatherFailures(body: body)
        XCTAssert(
            !failures.failures.isEmpty,
            "The code is expected to produce failures, but it didn't produce any failure",
            file: fileOfThisAssertion,
            line: lineOfThisAssertion
        )
    }
    
    func assertFails(
        description: String? = nil,
        file: String? = nil,
        line: Int? = nil,
        expected: Bool? = nil,
        fileOfThisAssertion: StaticString = #file,
        lineOfThisAssertion: UInt = #line,
        body: () -> ())
    {
        let failures = gatherFailures {
            body()
        }
        
        assertFails(
            descriptionMatcher: description.flatMap { EqualsMatcher($0) },
            file: file,
            line: line,
            expected: expected,
            failures: failures.failures,
            fileOfThisAssertion: fileOfThisAssertion,
            lineOfThisAssertion: lineOfThisAssertion
        )
    }
    
    func assertFails(
        description: String? = nil,
        expected: Bool? = nil,
        fileOfThisAssertion: StaticString = #file,
        lineOfThisAssertion: UInt = #line,
        body: (_ fails: FailsHereFunctionProvider) -> ())
    {
        let failsHereFunctionProvider = FailsHereFunctionProvider()
        let failures = gatherFailures {
            body(failsHereFunctionProvider)
        }
        
        assertFails(
            descriptionMatcher: description.flatMap { EqualsMatcher($0) },
            file: failsHereFunctionProvider.file,
            line: failsHereFunctionProvider.line,
            expected: expected,
            failures: failures.failures,
            fileOfThisAssertion: fileOfThisAssertion,
            lineOfThisAssertion: lineOfThisAssertion
        )
    }
    
    func assertPasses(
        fileOfThisAssertion: StaticString = #file,
        lineOfThisAssertion: UInt = #line,
        body: () -> ())
    {
        let failures = gatherFailures(body: body)
        XCTAssert(
            failures.failures.isEmpty,
            "The code is expected to not produce failures, but it produced failures: \(failures)",
            file: fileOfThisAssertion,
            line: lineOfThisAssertion
        )
    }
    
    func assert(
        passes: Bool,
        fileOfThisAssertion: StaticString = #file,
        lineOfThisAssertion: UInt = #line,
        body: () -> ())
    {
        if passes {
            assertPasses(
                fileOfThisAssertion: fileOfThisAssertion,
                lineOfThisAssertion: lineOfThisAssertion,
                body: body
            )
        } else {
            assertFails(
                fileOfThisAssertion: fileOfThisAssertion,
                lineOfThisAssertion: lineOfThisAssertion,
                body: body
            )
        }
    }
    
    func assertFails(
        descriptionMatcher: Matcher<String>? = nil,
        file: String? = nil,
        line: Int? = nil,
        expected: Bool? = nil,
        failures: [XcTestFailure],
        fileOfThisAssertion: StaticString = #file,
        lineOfThisAssertion: UInt = #line)
    {
        guard let firstFailure = failures.first else {
            XCTFail(
                "Code was expected to fail test, but it didn't",
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
            return
        }
        
        guard failures.count == 1 else {
            XCTFail(
                "failures.count \(failures.count) doesn't equal expected count 1",
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
            return
        }
        
        if let descriptionMatcher = descriptionMatcher {
            switch descriptionMatcher.matches(value: firstFailure.description) {
            case .match:
                break
            case .mismatch(let mismatchResult):
                XCTFail(
                    "Failure mismatches: \(mismatchResult.mismatchDescription)",
                    file: fileOfThisAssertion,
                    line: lineOfThisAssertion
                )
            }
        }
        
        if let file = file {
            XCTAssertEqual(
                firstFailure.file,
                file,
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
        }
        
        if let line = line {
            XCTAssertEqual(
                firstFailure.line,
                line,
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
        }
        
        if let expected = expected {
            XCTAssertEqual(
                firstFailure.expected,
                expected,
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
        }
    }
    
    func assertFails(
        failureDescriptionMatchesRegularExpression regularExpression: String,
        file: String? = nil,
        line: Int? = nil,
        expected: Bool? = nil,
        fileOfThisAssertion: StaticString = #file,
        lineOfThisAssertion: UInt = #line,
        body: () -> ())
    {
        let failures = gatherFailures {
            body()
        }
        
        assertFails(
            descriptionMatcher: RegularExpressionMatcher(regularExpression: regularExpression),
            file: file,
            line: line,
            expected: expected,
            failures: failures.failures,
            fileOfThisAssertion: fileOfThisAssertion,
            lineOfThisAssertion: lineOfThisAssertion
        )
    }
}
