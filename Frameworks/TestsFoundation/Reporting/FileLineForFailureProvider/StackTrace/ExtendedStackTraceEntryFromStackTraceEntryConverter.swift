public protocol ExtendedStackTraceEntryFromStackTraceEntryConverter: class {
    func extendedStackTraceEntry(stackTraceEntry: StackTraceEntry) -> ExtendedStackTraceEntry
}
