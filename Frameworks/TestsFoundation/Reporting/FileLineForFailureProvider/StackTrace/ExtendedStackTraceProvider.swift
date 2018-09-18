public protocol ExtendedStackTraceProvider {
    func extendedStackTrace() -> [ExtendedStackTraceEntry]
}
