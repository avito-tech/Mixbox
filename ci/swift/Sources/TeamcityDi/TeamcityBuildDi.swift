import DI
import Tasks
import Destinations
import CiFoundation
import SingletonHell
import Emcee
import Cocoapods
import CiDi
import Bundler
import TestRunning

public final class TeamcityBuildDependencies: CommonBuildDependencies {
    // swiftlint:disable:next function_body_length
    override public func registerDependenciesOfCurrentModule(di: DependencyRegisterer) {
        super.registerDependenciesOfCurrentModule(di: di)
        
        di.register(type: LocalTaskExecutor.self) { _ in
            TeamcityLocalTaskExecutor()
        }
        di.register(type: CocoapodsSearchOutputParser.self) { _ in
            CocoapodsSearchOutputParserImpl()
        }
        di.register(type: RemoteCacheConfigProvider.self) { di in
            let environmentProvider: EnvironmentProvider = try di.resolve()
            
            return try RemoteCacheConfigProviderImpl(
                remoteCacheConfigJsonFilePath: environmentProvider.getOrThrow(env: Env.MIXBOX_CI_EMCEE_REMOTE_CACHE_CONFIG)
            )
        }
        di.register(type: DeveloperDirProvider.self) { di in
            let environmentProvider: EnvironmentProvider = try di.resolve()
            
            return DeveloperDirProviderImpl(
                xcodeCFBundleShortVersionString: try environmentProvider.getOrThrow(
                    env: Env.MIXBOX_CI_XCODE_VERSION
                ) 
            )
        }
        di.register(type: SimulatorSettingsProvider.self) { di in
            try SimulatorSettingsProviderImpl(
                environmentProvider: di.resolve()
            )
        }
        di.register(type: CocoapodsTrunkTokenProvider.self) { di in
            try TeamcityCocoapodsTrunkTokenProvider(
                environmentProvider: di.resolve()
            )
        }
        di.register(type: BundlerBashCommandGenerator.self) { di in
            try BundlerBashCommandGeneratorImpl(
                gemfileLocationProvider: di.resolve(),
                bashEscapedCommandMaker: di.resolve(),
                bundlerToUse: .useSystem
            )
        }
        di.register(type: TestRunner.self) { di in
            let environmentProvider = try di.resolve() as EnvironmentProvider
            
            return try EmceeTestRunner(
                emceeProvider: di.resolve(),
                temporaryFileProvider: di.resolve(),
                bashExecutor: di.resolve(),
                queueServerRunConfigurationUrl: environmentProvider.getUrlOrThrow(
                    env: Env.MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL
                ),
                testArgFileJsonGenerator: di.resolve(),
                fileDownloader: di.resolve(),
                environmentProvider: di.resolve()
            )
        }
        di.register(type: CiLogger.self) { _ in
            TeamcityCiLogger()
        }
    }
}
