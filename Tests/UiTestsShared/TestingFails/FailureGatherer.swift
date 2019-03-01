import XCTest

protocol FailureGatherer {
    func gatherFailures(_ body: () -> ()) -> [XcTestFailure]
}

final class FailsHereFunctionProvider {
    var file: String?
    var line: Int?
    
    func here(file: String = #file, line: Int = #line) {
        self.file = file
        self.line = line
    }
}

// TODO: Remove singletons (XCTAssert)
extension FailureGatherer {
    func assertFails(
        fileOfThisAssertion: StaticString = #file,
        lineOfThisAssertion: UInt = #line,
        body: () -> ())
    {
        let failures = gatherFailures(body)
        XCTAssert(
            failures.count > 0,
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
            description: description,
            file: file,
            line: line,
            expected: expected,
            failures: failures,
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
            description: description,
            file: failsHereFunctionProvider.file,
            line: failsHereFunctionProvider.line,
            expected: expected,
            failures: failures,
            fileOfThisAssertion: fileOfThisAssertion,
            lineOfThisAssertion: lineOfThisAssertion
        )
    }
    
    func assertPasses(
        fileOfThisAssertion: StaticString = #file,
        lineOfThisAssertion: UInt = #line,
        body: () -> ())
    {
        let failures = gatherFailures(body)
        XCTAssert(
            failures.count == 0,
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
    
    private func assertFails(
        description: String?,
        file: String?,
        line: Int?,
        expected: Bool?,
        failures: [XcTestFailure],
        fileOfThisAssertion: StaticString,
        lineOfThisAssertion: UInt)
    {
        guard failures.count == 1 else {
            XCTFail(
                "failures.count (\(failures.count)) != 1",
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
            return
        }
        
        if let description = description {
            XCTAssertEqual(
                failures[0].description,
                description,
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
        }
        
        if let file = file {
            XCTAssertEqual(
                failures[0].file,
                file,
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
        }
        
        if let line = line {
            XCTAssertEqual(
                failures[0].line,
                line,
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
        }
        
        if let expected = expected {
            XCTAssertEqual(
                failures[0].expected,
                expected,
                file: fileOfThisAssertion,
                line: lineOfThisAssertion
            )
        }
    }
}
