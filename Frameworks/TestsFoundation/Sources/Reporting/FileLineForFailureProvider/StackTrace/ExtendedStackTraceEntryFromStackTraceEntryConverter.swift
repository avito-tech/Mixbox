public protocol ExtendedStackTraceEntryFromStackTraceEntryConverter: AnyObject {
    func extendedStackTraceEntry(stackTraceEntry: StackTraceEntry) -> ExtendedStackTraceEntry
}
