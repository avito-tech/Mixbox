public protocol ExtendedStackTraceEntryFromStackTraceEntryConverter {
    func extendedStackTraceEntry(stackTraceEntry: StackTraceEntry) -> ExtendedStackTraceEntry
}
