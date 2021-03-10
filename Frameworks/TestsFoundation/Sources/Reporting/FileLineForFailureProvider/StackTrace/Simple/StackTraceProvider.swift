// Should return array of trace with format as in backtrace_symbols
public protocol StackTraceProvider: class {
    func stackTrace() -> [StackTraceEntry]
}
