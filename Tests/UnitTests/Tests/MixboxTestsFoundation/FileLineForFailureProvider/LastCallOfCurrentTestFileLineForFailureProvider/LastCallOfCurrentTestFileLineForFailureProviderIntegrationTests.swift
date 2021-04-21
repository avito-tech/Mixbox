import XCTest
import MixboxFoundation
import MixboxTestsFoundation

// Tests are disabled. Symbolication using XCTest stopped working probably since Catalina.
final class LastCallOfCurrentTestFileLineForFailureProviderIntegrationTests: XCTestCase {
    private func currentFileLine(file: StaticString = #filePath, line: UInt = #line) -> RuntimeFileLine {
        return RuntimeFileLine(
            file: "\(file)",
            line: line
        )
    }
    
    private var provider = LastCallOfCurrentTestFileLineForFailureProvider(
        extendedStackTraceProvider: ExtendedStackTraceProviderImpl(
            stackTraceProvider: StackTraceProviderImpl(),
            extendedStackTraceEntryFromCallStackSymbolsConverter: ExtendedStackTraceEntryFromStackTraceEntryConverterImpl()
        ),
        testSymbolPatterns: [
            ".+?\\..+?\\.test.*?\\(\\) -> \\(\\)", // BlackBoxUiTests.FailuresTests.test_multipleMatchesFailure() -> ()
            "_thePaTteRn_"
        ]
    )
    
    // MARK: - Example
    
    func disabled_test() {
        XCTAssertEqual(provider.fileLineForFailure(), currentFileLine())
    }
    
    func disabled_test_withSuffix() {
        XCTAssertEqual(provider.fileLineForFailure(), currentFileLine())
    }
    
    // MARK: - Nesting
    
    func disabled_test_whenNestedFunctionDoesntMatchTestPattern() {
        XCTAssertEqual(nested(), currentFileLine())
    }
    
    private func nested() -> RuntimeFileLine? {
        return provider.fileLineForFailure()
    }
    
    func disabled_test_whenDoubleNestedFunctionDoesntMatchTestPattern() {
        XCTAssertEqual(double_nested(), currentFileLine())
    }
    
    private func double_nested() -> RuntimeFileLine? {
        return nested()
    }
    
    // MARK: - Files
    
    func disabled_test_otherFile() {
        var actualFileLine: RuntimeFileLine?
        var expectedFileLine: RuntimeFileLine?
        let otherFile = FileForStacktraceTestsWithFixedNameAndLineNumbers {
            // Other file will be ignored
            actualFileLine = self.provider.fileLineForFailure(); expectedFileLine = self.currentFileLine()
        }
        
        otherFile.func_line2()
        
        XCTAssertNotNil(expectedFileLine)
        XCTAssertEqual(actualFileLine, expectedFileLine)
    }
    
    // MARK: - Pattern
    
    func disabled_test_whenNestedFunctionMatchesTestPattern() {
        XCTAssertEqual(provider.fileLineForFailure(), currentFileLine())
        
        thisFunctionMatchesPattern_thePaTteRn_()
        XCTAssertEqual(thisFunctionDoesntMatchPattern_thepattern_(), currentFileLine())
    }
    
    func thisFunctionMatchesPattern_thePaTteRn_() {
        XCTAssertEqual(provider.fileLineForFailure(), currentFileLine())
    }
    
    func thisFunctionDoesntMatchPattern_thepattern_() -> RuntimeFileLine? {
        return provider.fileLineForFailure() // should return file/line of the caller (if it is called from test function)
    }
}
