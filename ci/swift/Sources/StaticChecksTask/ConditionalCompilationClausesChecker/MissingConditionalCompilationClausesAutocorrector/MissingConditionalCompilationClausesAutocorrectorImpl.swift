public final class MissingConditionalCompilationClausesAutocorrectorImpl: MissingConditionalCompilationClausesAutocorrector {
    private let ifClauseInfoByPathProvider: IfClauseInfoByPathProvider
    
    public init(ifClauseInfoByPathProvider: IfClauseInfoByPathProvider) {
        self.ifClauseInfoByPathProvider = ifClauseInfoByPathProvider
    }
    
    public func autocorrect(missingConditionalCompilationClauses: [MissingConditionalCompilationClause]) throws {
        try missingConditionalCompilationClauses.forEach(autocorrect)
    }
    
    public func autocorrect(missingConditionalCompilationClause: MissingConditionalCompilationClause) throws {
        let path = missingConditionalCompilationClause.fileNameWithMissingClause
        
        if let ifClauseInfo = ifClauseInfoByPathProvider.ifClauseInfo(path: path) {
            let originalContents = try String(contentsOfFile: path)
            
            var autocorrectedContents = ifClauseInfo.clauseOpening + "\n\n" + originalContents
            
            if !autocorrectedContents.hasSuffix("\n") {
                autocorrectedContents += "\n"
            }
            
            autocorrectedContents.append("\n" + ifClauseInfo.clauseClosing + "\n")
            
            try autocorrectedContents.write(toFile: path, atomically: true, encoding: .utf8)
        }
    }
}
