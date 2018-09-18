public final class ExtendedStackTraceEntry {
    public let file: String?
    public let line: UInt64?
    public let owner: String?
    public let symbol: String?
    public let demangledSymbol: String?
    public let address: UInt64

// sourcery:inline:auto:ExtendedStackTraceEntry.Init
    public init(
        file: String?,
        line: UInt64?,
        owner: String?,
        symbol: String?,
        demangledSymbol: String?,
        address: UInt64)
    {
        self.file = file
        self.line = line
        self.owner = owner
        self.symbol = symbol
        self.demangledSymbol = demangledSymbol
        self.address = address
    }
// sourcery:end
}
