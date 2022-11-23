public final class MissingConditionalCompilationClause: Hashable, Comparable, CustomDebugStringConvertible {
    public let frameworkName: String
    public let fileNameWithMissingClause: String
    
    public init(
        frameworkName: String,
        fileNameWithMissingClause: String)
    {
        self.frameworkName = frameworkName
        self.fileNameWithMissingClause = fileNameWithMissingClause
    }
    
    public static func ==(lhs: MissingConditionalCompilationClause, rhs: MissingConditionalCompilationClause) -> Bool {
        return lhs.fileNameWithMissingClause == rhs.fileNameWithMissingClause
            && lhs.frameworkName == rhs.frameworkName
    }
    
    public var debugDescription: String {
        return "MissingConditionalCompilationClause(frameworkName: \(frameworkName), fileNameWithMissingClause: \(fileNameWithMissingClause))"
    }
    
    public static func <(lhs: MissingConditionalCompilationClause, rhs: MissingConditionalCompilationClause) -> Bool {
        return (lhs.frameworkName, lhs.fileNameWithMissingClause)
            < (rhs.frameworkName, rhs.fileNameWithMissingClause)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(frameworkName)
        hasher.combine(fileNameWithMissingClause)
    }
}
