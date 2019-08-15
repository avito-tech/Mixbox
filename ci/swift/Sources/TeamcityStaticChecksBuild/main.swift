import BuildDsl
import StaticChecksTask

BuildDsl.teamcity.main { di in
    let ifClauseInfoByPathProvider = IfClauseInfoByPathProviderImpl()
    
    return try StaticChecksTask(
        swiftLint: SwiftLintImpl(
            processExecutor: di.resolve(),
            repoRootProvider: di.resolve()
        ),
        conditionalCompilationClausesChecker: ConditionalCompilationClausesCheckerImpl(
            missingConditionalCompilationClausesProvider: MissingConditionalCompilationClausesProviderImpl(
                frameworksDirectoryProvider: FrameworksDirectoryProviderImpl(
                    repoRootProvider: di.resolve()
                ),
                frameworkInfosProvider: FrameworkInfosProviderImpl(),
                ifClauseInfoByPathProvider: ifClauseInfoByPathProvider
            ),
            missingConditionalCompilationClausesAutocorrector: MissingConditionalCompilationClausesAutocorrectorImpl(
                ifClauseInfoByPathProvider: ifClauseInfoByPathProvider
            )
        )
    )
}
