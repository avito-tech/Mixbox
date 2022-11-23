public final class MissingConditionalCompilationClausesAutocorrectorImpl: MissingConditionalCompilationClausesAutocorrector {
    private let ifClauseInfoByPathProvider: IfClauseInfoByPathProvider
    
    public init(ifClauseInfoByPathProvider: IfClauseInfoByPathProvider) {
        self.ifClauseInfoByPathProvider = ifClauseInfoByPathProvider
    }
    
    public func autocorrect(missingConditionalCompilationClauses: Set<MissingConditionalCompilationClause>) throws {
        try missingConditionalCompilationClauses.forEach(autocorrect)
    }
    
    private func autocorrect(missingConditionalCompilationClause: MissingConditionalCompilationClause) throws {
        let filePath = missingConditionalCompilationClause.fileNameWithMissingClause
        
        if let ifClauseInfo = ifClauseInfoByPathProvider.ifClauseInfo(
            frameworkName: missingConditionalCompilationClause.frameworkName,
            filePath: filePath
        ) {
            try rewrite(filePath: filePath) { originalContents in
                autocorrect(
                    originalContents: originalContents,
                    ifClauseInfo: ifClauseInfo
                )
            }
        }
    }
    
    private func autocorrect(
        originalContents: String,
        ifClauseInfo: IfClauseInfo
    ) -> String {
        let oldSwiftClause = "#if MIXBOX_ENABLE_IN_APP_SERVICES"
        let oldObjectiveCClause = "#ifdef MIXBOX_ENABLE_IN_APP_SERVICES"
        
        if originalContents.contains(oldSwiftClause) {
            return replaceOldClause(
                originalContents: originalContents,
                oldClause: oldSwiftClause,
                ifClauseInfo: ifClauseInfo
            )
        } else if originalContents.contains(oldObjectiveCClause) {
            return replaceOldClause(
                originalContents: originalContents,
                oldClause: oldObjectiveCClause,
                ifClauseInfo: ifClauseInfo
            )
        } else {
            return addMissingClause(
                originalContents: originalContents,
                ifClauseInfo: ifClauseInfo
            )
        }
    }
    
    private func replaceOldClause(
        originalContents: String,
        oldClause: String,
        ifClauseInfo: IfClauseInfo
    ) -> String {
        originalContents.replacingOccurrences(
            of: oldClause,
            with: ifClauseInfo.disablingAndEnablingCompilation
        )
    }
    
    private func addMissingClause(
        originalContents: String,
        ifClauseInfo: IfClauseInfo
    ) -> String {
        var autocorrectedContents = ifClauseInfo.disablingAndEnablingCompilation + "\n\n" + originalContents
        
        if !autocorrectedContents.hasSuffix("\n") {
            autocorrectedContents += "\n"
        }
        
        autocorrectedContents.append("\n" + ifClauseInfo.closing + "\n")
        
        return autocorrectedContents
    }
    
    private func rewrite(
        filePath: String,
        transformContents: (String) -> String
    ) throws {
        try transformContents(
            String(contentsOfFile: filePath)
        ).write(toFile: filePath, atomically: true, encoding: .utf8)
    }
}
