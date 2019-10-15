public final class SwiftLintViolation: Equatable, CustomDebugStringConvertible {
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
    
    public static func ==(lhs: SwiftLintViolation, rhs: SwiftLintViolation) -> Bool {
        return lhs.file == rhs.file
            && lhs.line == rhs.line
            && lhs.column == rhs.column
            && lhs.type == rhs.type
            && lhs.description == rhs.description
            && lhs.rule == rhs.rule
    }
    
    public var debugDescription: String {
        return """
        SwiftLintViolation(
            file: \(file.debugDescription),
            line: \(line),
            column: \(column),
            type: .\(type),
            description: \(description.debugDescription),
            rule: \(rule.debugDescription),
        )
        """
    }
}
