// NOTE: To conditionally enable compilation, code should be inserted between `disablingAndEnablingCompilation` and `closing`.
// Other properties are for fine-tuning.
public final class IfClauseInfo {
    public let disablingCompilation: String        // #if ...
    public let disablingCompilationComment: String // // The compilation is disabled
    public let enablingCompilation: String         // #else ...
    public let closing: String                     // #endif
    
    public init(
        disablingCompilation: String,
        disablingCompilationComment: String,
        enablingCompilation: String,
        closing: String)
    {
        self.disablingCompilation = disablingCompilation
        self.disablingCompilationComment = disablingCompilationComment
        self.enablingCompilation = enablingCompilation
        self.closing = closing
    }
    
    public var disablingAndEnablingCompilation: String {
        [disablingCompilation, disablingCompilationComment, enablingCompilation].joined(separator: "\n")
    }
}
