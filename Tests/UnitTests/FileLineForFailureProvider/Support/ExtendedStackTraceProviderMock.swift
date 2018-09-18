import MixboxTestsFoundation

final class ExtendedStackTraceProviderMock: ExtendedStackTraceProvider {
    private let storedExtendedStackTrace: [ExtendedStackTraceEntry]
    
    init(extendedStackTrace: [ExtendedStackTraceEntry]) {
        storedExtendedStackTrace = extendedStackTrace
    }
    
    func extendedStackTrace() -> [ExtendedStackTraceEntry] {
        return storedExtendedStackTrace
    }
}
