public final class ExtendedStackTraceProviderImpl: ExtendedStackTraceProvider {
    private let stackTraceProvider: StackTraceProvider
    private let extendedStackTraceEntryFromCallStackSymbolsConverter: ExtendedStackTraceEntryFromStackTraceEntryConverter
    
    public init(
        stackTraceProvider: StackTraceProvider,
        extendedStackTraceEntryFromCallStackSymbolsConverter: ExtendedStackTraceEntryFromStackTraceEntryConverter)
    {
        self.stackTraceProvider = stackTraceProvider
        self.extendedStackTraceEntryFromCallStackSymbolsConverter = extendedStackTraceEntryFromCallStackSymbolsConverter
    }
    
    public func extendedStackTrace() -> [ExtendedStackTraceEntry] {
        return stackTraceProvider.stackTrace().map {
            extendedStackTraceEntryFromCallStackSymbolsConverter.extendedStackTraceEntry(
                stackTraceEntry: $0
            )
        }
    }
}
