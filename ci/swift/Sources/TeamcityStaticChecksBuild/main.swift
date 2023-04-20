import BuildDsl
import StaticChecksTask
import SingletonHell
import CiFoundation
import Tasks
import DI

public final class TeamcityStaticChecksBuild: TeamcityBuild {
    // TODO: Do not override anything?
    override public func di() -> DependencyInjection {
        let di = super.di()
        
        di.register(type: FilesEnumerator.self) { _ in
            FilesEnumeratorImpl()
        }
        di.register(type: IfClauseInfoByPathProvider.self) { _ in
            IfClauseInfoByPathProviderImpl()
        }
        di.register(type: SwiftLintViolationsParser.self) { _ in
            SwiftLintViolationsParserImpl()
        }
        di.register(type: FrameworkInfosProvider.self) { _ in
            FrameworkInfosProviderImpl()
        }
        di.register(type: FrameworksDirectoryProvider.self) { di in
            try FrameworksDirectoryProviderImpl(
                repoRootProvider: di.resolve()
            )
        }
        di.register(type: MixboxFrameworksEnumerator.self) { di in
            try MixboxFrameworksEnumeratorImpl(
                filesEnumerator: di.resolve(),
                frameworksDirectoryProvider: di.resolve()
            )
        }
        di.register(type: IfClauseInfoByPathProvider.self) { _ in
            IfClauseInfoByPathProviderImpl()
        }
        di.register(type: MissingConditionalCompilationClausesProvider.self) { di in
            try MissingConditionalCompilationClausesProviderImpl(
                frameworkInfosProvider: di.resolve(),
                filesEnumerator: di.resolve(),
                mixboxFrameworksEnumerator: di.resolve(),
                ifClauseInfoByPathProvider: di.resolve()
            )
        }
        di.register(type: MissingConditionalCompilationClausesAutocorrector.self) { di in
            try MissingConditionalCompilationClausesAutocorrectorImpl(
                ifClauseInfoByPathProvider: di.resolve()
            )
        }
        di.register(type: ConditionalCompilationClausesChecker.self) { di in
            let environmentProvider: EnvironmentProvider = try di.resolve()
            
            return try ConditionalCompilationClausesCheckerImpl(
                missingConditionalCompilationClausesProvider: di.resolve(),
                missingConditionalCompilationClausesAutocorrector: di.resolve(),
                autocorrectionIsEnabled: environmentProvider.get(env: Env.MIXBOX_CI_AUTOCORRECT_ENABLED) == "true"
            )
        }
        di.register(type: SwiftLint.self) { di in
            try SwiftLintImpl(
                processExecutor: di.resolve(),
                repoRootProvider: di.resolve(),
                swiftLintViolationsParser: di.resolve(),
                cocoapodsInstall: di.resolve()
            )
        }
        
        return di
    }
    
    public func task(di: DependencyResolver) throws -> LocalTask  {
        try StaticChecksTask(
            swiftLint: di.resolve(),
            conditionalCompilationClausesChecker: di.resolve()
        )
    }
}

BuildRunner.run(
    build: TeamcityStaticChecksBuild()
)
