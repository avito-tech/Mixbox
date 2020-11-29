import MixboxFoundation

public class LastCallOfCurrentTestFileLineForFailureProvider: FileLineForFailureProvider {
    private let extendedStackTraceProvider: ExtendedStackTraceProvider
    private let testSymbolPatterns: [String]
    
    // TODO: Extract regex logic to a class (that can say if entry is of test function)
    public init(
        extendedStackTraceProvider: ExtendedStackTraceProvider,
        testSymbolPatterns: [String])
    {
        self.extendedStackTraceProvider = extendedStackTraceProvider
        self.testSymbolPatterns = testSymbolPatterns
    }
    
    private func isTest(_ entry: ExtendedStackTraceEntry) -> Bool {
        guard let demangledSymbol = entry.demangledSymbol else {
            return false
        }
        guard hasFileLine(entry) else {
            return false
        }
        
        for pattern in testSymbolPatterns {
            if demangledSymbol.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil {
                return true
            }
        }
        
        return false
    }
    
    private func hasFileLine(_ entry: ExtendedStackTraceEntry) -> Bool {
        return entry.file != nil && entry.line != nil
    }
    
    public func fileLineForFailure() -> RuntimeFileLine? {
        let stack = extendedStackTraceProvider.extendedStackTrace()
        
        let topEntryOrNil = stack.reversed().first { hasFileLine($0) && isTest($0) }
            // fallbacks:
            ?? stack.reversed().first { hasFileLine($0) }
        
        guard let topEntry = topEntryOrNil, let fileFromTopEntry = topEntry.file else {
            return nil
        }
        
        let entryOrNil = stack.first(where: { $0.file == fileFromTopEntry && isTest($0) })
            // fallbacks:
            ?? stack.first(where: { $0.file == fileFromTopEntry && hasFileLine($0) })
            ?? stack.first(where: { isTest($0) })
            ?? stack.first(where: { hasFileLine($0) })
        
        if let entry = entryOrNil, let file = entry.file, let line = entry.line {
            return RuntimeFileLine(file: file, line: line)
        } else {
            return nil
        }
    }
}
