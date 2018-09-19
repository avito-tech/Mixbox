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
    func assertFails(body: () -> ()) {
        let failures = gatherFailures(body)
        XCTAssert(
            failures.count > 0,
            "The code is expected to produce failures, but it didn't produce any failure"
        )
    }
    
    func assertFails(
        description: String? = nil,
        file: String? = nil,
        line: Int? = nil,
        expected: Bool? = nil,
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
            failures: failures
        )
    }
    
    func assertFails(
        description: String? = nil,
        expected: Bool? = nil,
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
            failures: failures
        )
    }
    
    func assertPasses(body: () -> ()) {
        let failures = gatherFailures(body)
        XCTAssert(
            failures.count == 0,
            "The code is expected to not produce failures, but it produced failures: \(failures)"
        )
    }
    
    func assert(passes: Bool, body: () -> ()) {
        if passes {
            assertPasses(body: body)
        } else {
            assertFails(body: body)
        }
    }
    
    private func assertFails(
        description: String?,
        file: String?,
        line: Int?,
        expected: Bool?,
        failures: [XcTestFailure])
    {
        guard failures.count == 1 else {
            XCTFail("failures.count (\(failures.count)) != 1")
            return
        }
        
        if let description = description {
            XCTAssertEqual(failures[0].description, description)
        }
        if let file = file {
            XCTAssertEqual(failures[0].file, file)
        }
        if let line = line {
            XCTAssertEqual(failures[0].line, line)
        }
        if let expected = expected {
            XCTAssertEqual(failures[0].expected, expected)
        }
    }
}
