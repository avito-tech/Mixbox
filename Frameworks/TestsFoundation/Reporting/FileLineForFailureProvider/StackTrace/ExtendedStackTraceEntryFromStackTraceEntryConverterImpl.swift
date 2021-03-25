import XCTest
import MixboxFoundation

// TODO: Split:
// - Parsing output of backtrace_symbols
// - Symbolication of callstack addresses
//
// Add note in new class for symbolication that alternative implementation is possible with:
// - atos (requires fork() and thus unavailable on real iOS device)
// - lldb (requires fork() and thus unavailable on real iOS device)
// - CoreSymbolication (a private API that is used by every
//   Apple symbolication utility, uncluding `_symbolicationRecordForTestCode`)
//
public final class ExtendedStackTraceEntryFromStackTraceEntryConverterImpl: ExtendedStackTraceEntryFromStackTraceEntryConverter {
    private let regex = try? NSRegularExpression(
        pattern: "^[0-9]+\\s+(.+?)\\s+0x[0-9a-fA-F]+\\s+(.*?)\\s+\\+\\s+[0-9]+$",
        options: []
    )
    
    public init() {
    }
    
    public func extendedStackTraceEntry(stackTraceEntry: StackTraceEntry) -> ExtendedStackTraceEntry {
        var file: String?
        var line: UInt?
        var owner: String?
        var symbol: String?
        var demangledSymbol: String?
        
        detectSymbolAndOwner(
            stackTraceEntry: stackTraceEntry,
            symbol: &symbol,
            owner: &owner
        )
        
        symbolicate(
            address: stackTraceEntry.address,
            file: &file,
            line: &line,
            owner: &owner,
            symbol: &symbol
        )
        
        if let symbol = symbol {
            demangledSymbol = _stdlib_demangleName(symbol)
        }
        
        return ExtendedStackTraceEntry(
            file: file,
            line: line,
            owner: owner,
            symbol: symbol,
            demangledSymbol: demangledSymbol,
            address: stackTraceEntry.address
        )
    }
    
    // Better than `detectSymbolAndOwner`, because it also detects file and line, but it can fail in some cases (when
    // compiled without symbols or when source code is not available, the latter was at least true for Xcode 11 and lower).
    private func symbolicate(
        address: UInt64,
        file: inout String?,
        line: inout UInt?,
        owner: inout String?,
        symbol: inout String?)
    {
        fatalError()
//        #if compiler(>=5.3)
//        // Xcode 12+
//
//        // Suppresses `Cast from 'XCTSymbolicationService?' to unrelated type 'XCTInProcessSymbolicationService' always fails` warning.
//        let sharedSymbolicationService = XCTSymbolicationService.shared() as AnyObject
//        if let symbolicationService = sharedSymbolicationService as? XCTInProcessSymbolicationService {
//            // TODO: Assertion error
//            let untypedSymbolInfo = symbolicationService.symbolInfoForAddress(inCurrentProcess: address, error: nil)
//
//            // TODO: Check if "<unknown>" really applicable here with new API. Write tests.
//            if let symbolInfo = untypedSymbolInfo as? XCTSourceCodeSymbolInfo {
//                if let location = symbolInfo.location {
//                    file = location.fileURL.absoluteString == "<unknown>" ? file : location.fileURL.path
//                    line = location.lineNumber == 0
//                        ? line
//                        : SourceCodeLineTypeConverter.convert(line: location.lineNumber)
//                }
//                owner = symbolInfo.imageName == "<unknown>" ? owner : symbolInfo.imageName
//                symbol = symbolInfo.symbolName == "<unknown>" ? symbol : symbolInfo.symbolName
//            }
//        }
//        #else
//        if let record = (XCTestCase()._symbolicationRecordForTestCode(inAddressStack: NSArray(array: [NSNumber(value: address)])) as? XCSymbolicationRecord) ?? (XCSymbolicationRecord.symbolicationRecord(forAddress: address) as? XCSymbolicationRecord) {
//            file = record.filePath == "<unknown>" ? file : record.filePath
//            line = record.lineNumber == 0 ? line : SourceCodeLineTypeConverter.convert(line: record.lineNumber)
//            owner = record.symbolOwner == "<unknown>" ? owner : record.symbolOwner
//            symbol = record.symbolName == "<unknown>" ? symbol : record.symbolName
//        }
//        #endif
    }
    
    private func detectSymbolAndOwner(
        stackTraceEntry: StackTraceEntry,
        symbol: inout String?,
        owner: inout String?)
    {
        if let stackTraceEntrySymbol = stackTraceEntry.symbol, let regex = regex {
            let matches = regex.matchesIn(string: stackTraceEntrySymbol)
            
            if let match = matches.first, matches.count == 1, match.count == 3 {
                owner = match[1] == "???" ? owner : match[1]
                symbol = match[2] == "0x0" ? symbol : match[2]
            }
        }
    }
}

private extension NSRegularExpression {
    func matchesIn(string: String) -> [[String]] {
        let matches = self.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        
        return matches.map { match in
            (0..<match.numberOfRanges).map { rangeIndex in
                let range = match.range(at: rangeIndex)
                
                return String(string.utf16.prefix(range.location + range.length).suffix(range.length)) ?? ""
            }
        }
    }
}

// From: https://github.com/johnno1962/SwiftTrace/blob/master/SwiftTrace/SwiftTrace.swift
@_silgen_name("swift_demangle")
public func _stdlib_demangleImpl(
    _ mangledName: UnsafePointer<CChar>?,
    mangledNameLength: UInt,
    outputBuffer: UnsafeMutablePointer<UInt8>?,
    outputBufferSize: UnsafeMutablePointer<UInt>?,
    flags: UInt32)
    -> UnsafeMutablePointer<CChar>?

func _stdlib_demangleName(_ mangledName: String) -> String {
    return mangledName.utf8CString.withUnsafeBufferPointer { mangledNameUTF8 in
        let demangledNamePtr = _stdlib_demangleImpl(
            mangledNameUTF8.baseAddress,
            mangledNameLength: UInt(mangledNameUTF8.count - 1),
            outputBuffer: nil,
            outputBufferSize: nil,
            flags: 0)
        
        if let demangledNamePtr = demangledNamePtr {
            let demangledName = String(cString: demangledNamePtr)
            free(demangledNamePtr)
            return demangledName
        }
        
        return mangledName
    }
}
