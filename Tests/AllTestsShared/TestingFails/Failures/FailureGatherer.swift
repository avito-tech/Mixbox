import XCTest
import MixboxTestsFoundation

protocol FailureGatherer: AnyObject {
    func gatherFailures<T>(body: () -> (T)) -> GatherFailuresResult<T>
}

// TODO: Remove singletons (XCTAssert)
extension FailureGatherer {
    func assertFails(
        fileOfThisAssertion: StaticString = #filePath,
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
        line: UInt? = nil,
        expected: Bool? = nil,
        fileOfThisAssertion: StaticString = #filePath,
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
        fileOfThisAssertion: StaticString = #filePath,
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
        fileOfThisAssertion: StaticString = #filePath,
        lineOfThisAssertion: UInt = #line,
        body: () -> ())
    {
        assertPasses(
            fileOfThisAssertion: fileOfThisAssertion,
            lineOfThisAssertion: lineOfThisAssertion,
            message: { failures in
                "The code is expected to not produce failures, but it produced failures: \(failures)"
            },
            body: body
        )
    }
    
    func assertPasses(
        fileOfThisAssertion: StaticString = #filePath,
        lineOfThisAssertion: UInt = #line,
        message: ([XcTestFailure]) -> String,
        body: () -> ())
    {
        let result = gatherFailures(body: body)
        
        XCTAssert(
            result.failures.isEmpty,
            message(result.failures),
            file: fileOfThisAssertion,
            line: lineOfThisAssertion
        )
    }
    
    func assert(
        passes: Bool,
        fileOfThisAssertion: StaticString = #filePath,
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

    // swiftlint:disable:next function_body_length
    func assertFails(
        descriptionMatcher: Matcher<String>? = nil,
        file: String? = nil,
        line: UInt? = nil,
        expected: Bool? = nil,
        failures: [XcTestFailure],
        fileOfThisAssertion: StaticString = #filePath,
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
            switch descriptionMatcher.match(value: firstFailure.description) {
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
        line: UInt? = nil,
        expected: Bool? = nil,
        fileOfThisAssertion: StaticString = #filePath,
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
