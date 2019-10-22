import XCTest

extension TestCase {
    func assertThrows(error expectedError: String, file: StaticString = #file, line: UInt = #line, body: () throws -> ()) {
        var actualError: String?
        
        do {
            try body()
        } catch {
            actualError = "\(error)"
        }
        
        if let actualError = actualError {
            XCTAssertEqual(
                actualError,
                expectedError,
                "Code was expected to throw error with message:\n\(expectedError)\n\nBut it threw:\n\(actualError)",
                file: file,
                line: line
            )
        } else {
            XCTFail(
                "Code was expected to throw error, but it didn't throw",
                file: file,
                line: line
            )
        }
    }
    
    func assertDoesntThrow(file: StaticString = #file, line: UInt = #line, body: () throws -> ()) {
        do {
            try body()
        } catch {
            XCTFail(
                "Code was expected to not throw error, but it threw: \(error)",
                file: file,
                line: line
            )
        }
    }
}
