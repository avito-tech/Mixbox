import BuildDsl
import StaticChecksTask

BuildDsl.teamcity.main(
    diOverrides: { di in
        di.register(type: FilesEnumerator.self) {
            FilesEnumeratorImpl()
        }
        di.register(type: IfClauseInfoByPathProvider.self) {
            IfClauseInfoByPathProviderImpl()
        }
        di.register(type: SwiftLintViolationsParser.self) {
            SwiftLintViolationsParserImpl()
        }
        di.register(type: FrameworkInfosProvider.self) {
            FrameworkInfosProviderImpl()
        }
        di.register(type: FrameworksDirectoryProvider.self) {
            FrameworksDirectoryProviderImpl(
                repoRootProvider: try di.resolve()
            )
        }
        di.register(type: MixboxFrameworksEnumerator.self) {
            MixboxFrameworksEnumeratorImpl(
                filesEnumerator: try di.resolve(),
                frameworksDirectoryProvider: try di.resolve()
            )
        }
        di.register(type: IfClauseInfoByPathProvider.self) {
            IfClauseInfoByPathProviderImpl()
        }
        di.register(type: MissingConditionalCompilationClausesProvider.self) {
            MissingConditionalCompilationClausesProviderImpl(
                frameworkInfosProvider: try di.resolve(),
                filesEnumerator: try di.resolve(),
                mixboxFrameworksEnumerator: try di.resolve(),
                ifClauseInfoByPathProvider: try di.resolve()
            )
        }
        di.register(type: MissingConditionalCompilationClausesAutocorrector.self) {
            MissingConditionalCompilationClausesAutocorrectorImpl(
                ifClauseInfoByPathProvider: try di.resolve()
            )
        }
        di.register(type: ConditionalCompilationClausesChecker.self) {
            ConditionalCompilationClausesCheckerImpl(
                missingConditionalCompilationClausesProvider: try di.resolve(),
                missingConditionalCompilationClausesAutocorrector: try di.resolve()
            )
        }
        di.register(type: SwiftLint.self) {
            SwiftLintImpl(
                processExecutor: try di.resolve(),
                repoRootProvider: try di.resolve(),
                swiftLintViolationsParser: try di.resolve(),
                cocoapodsFactory: try di.resolve()
            )
        }
    },
    makeLocalTask: { di in
        try StaticChecksTask(
            swiftLint: di.resolve(),
            conditionalCompilationClausesChecker: di.resolve()
        )
    }
)
