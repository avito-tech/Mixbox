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
        var line: UInt64?
        var owner: String?
        var symbol: String?
        var demangledSymbol: String?
        
        if let stackTraceEntrySymbol = stackTraceEntry.symbol, let regex = regex {
            let matches = regex.matchesIn(string: stackTraceEntrySymbol)
            
            if let match = matches.first, matches.count == 1, match.count == 3 {
                owner = match[1] == "???" ? owner : match[1]
                symbol = match[2] == "0x0" ? symbol : match[2]
            }
        }
        
        if let record = (XCTestCase()._symbolicationRecordForTestCode(inAddressStack: NSArray(array: [NSNumber(value: stackTraceEntry.address)])) as? XCSymbolicationRecord) ?? (XCSymbolicationRecord.symbolicationRecord(forAddress: stackTraceEntry.address) as? XCSymbolicationRecord) {
            file = record.filePath == "<unknown>" ? file : record.filePath
            line = record.lineNumber == 0 ? line : record.lineNumber
            owner = record.symbolOwner == "<unknown>" ? owner : record.symbolOwner
            symbol = record.symbolName == "<unknown>" ? symbol : record.symbolName
        }
        
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
