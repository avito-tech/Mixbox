import MixboxFoundation

public class FirstOfTargetFileFromCallStackFileLineForFailureProvider: FileLineForFailureProvider {
    private let extendedStackTraceProvider: ExtendedStackTraceProvider
    private let file: String
    
    public init(extendedStackTraceProvider: ExtendedStackTraceProvider, file: String) {
        self.extendedStackTraceProvider = extendedStackTraceProvider
        self.file = file
    }
    
    public func fileLineForFailure() -> RuntimeFileLine? {
        let stack = extendedStackTraceProvider.extendedStackTrace()
        
        let entryOrNil = stack.first(where: { entry in entry.file == file && entry.line != nil })
            ?? stack.first(where: { entry in entry.file == file })
            ?? stack.first(where: { entry in entry.file != nil && entry.line != nil })
        
        if let entry = entryOrNil, let file = entry.file, let line = entry.line {
            return RuntimeFileLine(file: file, line: line)
        } else {
            return nil
        }
    }
}
