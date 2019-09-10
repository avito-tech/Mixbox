import XCTest
import MixboxTestsFoundation
import MixboxFoundation

final class ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests: XCTestCase {
    private let converter = ExtendedStackTraceEntryFromStackTraceEntryConverterImpl()
    
    func test_fallback_0() {
        let entry = converter.extendedStackTraceEntry(
            stackTraceEntry: StackTraceEntry(
                symbol: "0   ???                                 0x123456789abcdef0 0x0 + 123456789",
                address: 0x123456789abcdef0
            )
        )
        
        check(
            entry: entry,
            file: nil,
            line: nil,
            owner: nil,
            symbol: nil,
            demangledSymbol: nil,
            address: 0x123456789abcdef0
        )
    }
    
    func test_fallback_1() {
        let entry = converter.extendedStackTraceEntry(
            stackTraceEntry: StackTraceEntry(
                symbol: "2   xctest                              0x000000010e7a0069 main + 0",
                address: 0x123456789abcdef0
            )
        )
        
        check(
            entry: entry,
            file: nil,
            line: nil,
            owner: "xctest",
            symbol: "main",
            demangledSymbol: "main",
            address: 0x123456789abcdef0
        )
    }
    
    func test_onRealTestMethod() {
        let targetName = "UnitTests"
        let stackTrace = StackTraceProviderImpl().stackTrace(); let file = "\(#file)"; let line = UInt64(#line)
        
        guard let simpleEntry = stackTrace.first(where: { $0.symbol?.contains(targetName) == true }) else {
            XCTFail("Unable to perform test")
            return
        }
        
        let entry = converter.extendedStackTraceEntry(
            stackTraceEntry: simpleEntry
        )
        
        XCTAssertEqual(
            entry.file?.mb_lastPathComponent,
            "ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests.swift"
        )
        
        check(
            entry: entry,
            file: file,
            line: line,
            owner: "UnitTests",
            symbolInXcode10_1_or_10_0: "$S9UnitTests027ExtendedStackTraceEntryFromdef13ConverterImplB0C21test_onRealTestMethodyyF",
            symbolInXcode10_2_1: "$s9UnitTests027ExtendedStackTraceEntryFromdef13ConverterImplB0C21test_onRealTestMethodyyF",
            demangledSymbol: "UnitTests.ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests.test_onRealTestMethod() -> ()",
            address: simpleEntry.address
        )
    }
    
    private func check(
        entry: ExtendedStackTraceEntry,
        file: String?,
        line: UInt64?,
        owner: String?,
        symbol: String?,
        demangledSymbol: String?,
        address: UInt64,
        fileWhereExecuted: StaticString = #file,
        lineWhereExecuted: UInt = #line)
    {
        check(
            entry: entry,
            file: file,
            line: line,
            owner: owner,
            symbolInXcode10_1_or_10_0: symbol,
            symbolInXcode10_2_1: symbol,
            demangledSymbol: demangledSymbol,
            address: address,
            fileWhereExecuted: fileWhereExecuted,
            lineWhereExecuted: lineWhereExecuted
        )
    }
    
    // TODO: Invent a way to check Xcode version in Swift or somehow deal with different symbols in different Xcodes
    private func check(
        entry: ExtendedStackTraceEntry,
        file: String?,
        line: UInt64?,
        owner: String?,
        symbolInXcode10_1_or_10_0: String?,
        symbolInXcode10_2_1: String?,
        demangledSymbol: String?,
        address expectedAddress: UInt64,
        fileWhereExecuted: StaticString = #file,
        lineWhereExecuted: UInt = #line)
    {
        XCTAssert(
            entry.file == file,
            "Expected file: \(file.descriptionOrNil()), actual: \(entry.file.descriptionOrNil())",
            file: fileWhereExecuted,
            line: lineWhereExecuted
        )
        XCTAssert(
            entry.line == line,
            "Expected line: \(line.descriptionOrNil()), actual: \(entry.line.descriptionOrNil())",
            file: fileWhereExecuted,
            line: lineWhereExecuted
        )
        XCTAssert(
            entry.owner == owner,
            "Expected owner: \(owner.descriptionOrNil()), actual: \(entry.owner.descriptionOrNil())",
            file: fileWhereExecuted,
            line: lineWhereExecuted
        )
        
        let actualSymbol = entry.symbol
        if actualSymbol != symbolInXcode10_2_1 && actualSymbol != symbolInXcode10_1_or_10_0 {
            XCTFail(
                "Expected symbol: \(symbolInXcode10_2_1.descriptionOrNil()) or \(symbolInXcode10_1_or_10_0.descriptionOrNil()), actual: \(actualSymbol.descriptionOrNil())",
                file: fileWhereExecuted,
                line: lineWhereExecuted
            )
        }
        
        XCTAssert(
            entry.demangledSymbol == demangledSymbol,
            "Expected demangledSymbol: \(demangledSymbol.descriptionOrNil()), actual: \(entry.demangledSymbol.descriptionOrNil())",
            file: fileWhereExecuted,
            line: lineWhereExecuted
        )
        
        XCTAssert(
            entry.address == expectedAddress,
            "Expected address: \(expectedAddress), actual: \(entry.address)",
            file: fileWhereExecuted,
            line: lineWhereExecuted
        )
    }
}
