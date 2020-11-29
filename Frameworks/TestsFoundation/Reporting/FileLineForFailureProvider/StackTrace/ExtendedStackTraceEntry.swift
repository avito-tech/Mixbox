public final class ExtendedStackTraceEntry {
    public let file: String?
    public let line: UInt?
    public let owner: String?
    public let symbol: String?
    public let demangledSymbol: String?
    public let address: UInt64

    public init(
        file: String?,
        line: UInt?,
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
}
