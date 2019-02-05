public final class TestReportFailure {
    public let description: String
    public let file: String
    public let line: Int

// sourcery:inline:auto:TestReportFailure.Init
    public init(
        description: String,
        file: String,
        line: Int)
    {
        self.description = description
        self.file = file
        self.line = line
    }
// sourcery:end
}
