public final class SwiftLintViolation {
    public let file: String
    public let line: Int
    public let column: Int
    public let type: SwiftLintViolationType
    public let description: String
    public let rule: String
    
    public init(
        file: String,
        line: Int,
        column: Int,
        type: SwiftLintViolationType,
        description: String,
        rule: String)
    {
        self.file = file
        self.line = line
        self.column = column
        self.type = type
        self.description = description
        self.rule = rule
    }
}
