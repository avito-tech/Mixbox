import BuildDsl
import StaticChecksTask

BuildDsl.teamcity.main { di in
    let ifClauseInfoByPathProvider = IfClauseInfoByPathProviderImpl()
    let filesEnumerator = FilesEnumeratorImpl()
    
    return try StaticChecksTask(
        swiftLint: SwiftLintImpl(
            processExecutor: di.resolve(),
            repoRootProvider: di.resolve(),
            swiftLintViolationsParser: SwiftLintViolationsParserImpl(),
            cocoapodsFactory: di.resolve()
        ),
        conditionalCompilationClausesChecker: ConditionalCompilationClausesCheckerImpl(
            missingConditionalCompilationClausesProvider: MissingConditionalCompilationClausesProviderImpl(
                frameworkInfosProvider: FrameworkInfosProviderImpl(),
                filesEnumerator: filesEnumerator,
                mixboxFrameworksEnumerator: MixboxFrameworksEnumeratorImpl(
                    filesEnumerator: filesEnumerator,
                    frameworksDirectoryProvider: FrameworksDirectoryProviderImpl(
                        repoRootProvider: di.resolve()
                    )
                ),
                ifClauseInfoByPathProvider: ifClauseInfoByPathProvider
            ),
            missingConditionalCompilationClausesAutocorrector: MissingConditionalCompilationClausesAutocorrectorImpl(
                ifClauseInfoByPathProvider: ifClauseInfoByPathProvider
            )
        )
    )
}
