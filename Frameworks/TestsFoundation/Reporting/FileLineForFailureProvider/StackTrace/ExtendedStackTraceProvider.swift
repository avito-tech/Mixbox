public protocol ExtendedStackTraceProvider: class {
    func extendedStackTrace() -> [ExtendedStackTraceEntry]
}
