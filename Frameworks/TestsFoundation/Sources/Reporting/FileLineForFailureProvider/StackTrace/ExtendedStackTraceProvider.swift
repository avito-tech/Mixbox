public protocol ExtendedStackTraceProvider: AnyObject {
    func extendedStackTrace() -> [ExtendedStackTraceEntry]
}
