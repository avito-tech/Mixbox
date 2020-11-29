import XCTest
import MixboxTestsFoundation
import MixboxFoundation

final class ExtendedStackTraceProviderImplTests: XCTestCase {
    private func currentFileLine(file: StaticString = #file, line: UInt = #line) -> RuntimeFileLine {
        return RuntimeFileLine(
            file: "\(file)",
            line: line
        )
    }
    
    private var provider = ExtendedStackTraceProviderImpl(
        stackTraceProvider: StackTraceProviderImpl(),
        extendedStackTraceEntryFromCallStackSymbolsConverter: ExtendedStackTraceEntryFromStackTraceEntryConverterImpl()
    )
    
    // TODO: Option to remove stacktrace of functions that generate stacktrace?
    func disabled_test_returns_same_count_of_entries_as_thread() {
        XCTAssertEqual(Thread.callStackReturnAddresses.count, provider.extendedStackTrace().count)
        XCTAssertEqual(Thread.callStackSymbols.count, provider.extendedStackTrace().count)
    }
    
    // Symbolication using XCTest stopped working probably since Catalina
    func disabled_test_on_real_trace() {
        var traceOrNil: [ExtendedStackTraceEntry]?
        let specialFile = FileForStacktraceTestsWithFixedNameAndLineNumbers {
            traceOrNil = self.provider.extendedStackTrace()
        }
        specialFile.func_line2()
        
        guard let trace = traceOrNil, trace.count > 5 else {
            XCTFail("Did not receive trace from extendedStackTrace()")
            return
        }
        
        let xcodeVersion = XcodeVersionProvider.xcodeVersionOrFail()
        
        let traceEntry: ExtendedStackTraceEntry = xcodeVersion.major >= 11
            ? trace[4]
            : trace[5]
        
        XCTAssertEqual(traceEntry.file?.mb_lastPathComponent, "FileForStacktraceTestsWithFixedNameAndLineNumbers.swift")
        XCTAssertEqual(traceEntry.line, 10)
        XCTAssertEqual(traceEntry.owner, "UnitTests")
        
        let actualSymbol = traceEntry.symbol
        let expectedSymbol: String
        
        if xcodeVersion >= XcodeVersion.xcode_10_2_1 {
            expectedSymbol = "$s9UnitTests017FileForStacktraceB27WithFixedNameAndLineNumbersC11func_line10yyF"
        } else {
            expectedSymbol = "$S9UnitTests017FileForStacktraceB27WithFixedNameAndLineNumbersC11func_line10yyF"
        }
        
        if actualSymbol != expectedSymbol {
            XCTFail(
                "Expected symbol: \(expectedSymbol), actual: \(String(describing: actualSymbol))"
            )
        }
        
        XCTAssertEqual(traceEntry.demangledSymbol, "UnitTests.FileForStacktraceTestsWithFixedNameAndLineNumbers.func_line10() -> ()")
    }
}
