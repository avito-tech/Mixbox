public final class StackTraceEntry {
    public let symbol: String?
    public let address: UInt64

// sourcery:inline:auto:StackTraceEntry.Init
    public init(
        symbol: String?,
        address: UInt64)
    {
        self.symbol = symbol
        self.address = address
    }
// sourcery:end
}
