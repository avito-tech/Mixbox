import DI
import Bash
import CiFoundation
import Tasks
import Cocoapods
import Git
import Simctl
import Foundation
import Emcee
import SingletonHell
import RemoteFiles
import Xcodebuild
import Destinations
import Bundler
import Releases
import TestRunning
import FileSystem

// swiftlint:disable file_length function_body_length type_body_length
open class CommonBuildDependencies: ModuleDependencies, InitializableWithNoArguments {
    public required init() {
    }
    
    open func registerDependenciesOfCurrentModule(di: DependencyRegisterer) {
        registerGit(di: di)
        registerCocoapods(di: di)
        registerReleases(di: di)
        registerBash(di: di)
        registerRemoteFiles(di: di)
        registerEmcee(di: di)
        registerBundler(di: di)
        registerCiFoundation(di: di)
        registerDestinations(di: di)
        registerXcodebuild(di: di)
        registerSimctl(di: di)
        registerTestRunning(di: di)
    }
    
    public func otherModulesDependecies() -> [ModuleDependencies] {
        [
            FileSystemModuleDependencies()
        ]
    }
    
    private func registerGit(di: DependencyRegisterer) {
        di.register(type: RepoRootProvider.self) { _ in
            RepoRootProviderImpl()
        }
        di.register(type: GitTagsProvider.self) { di in
            try GitTagsProviderImpl(
                gitCommandExecutor: di.resolve()
            )
        }
        di.register(type: GitRevListProvider.self) { di in
            try GitRevListProviderImpl(
                gitCommandExecutor: di.resolve()
            )
        }
        di.register(type: HeadCommitHashProvider.self) { di in
            try HeadCommitHashProviderImpl(
                gitCommandExecutor: di.resolve()
            )
        }
        di.register(type: GitTagAdder.self) { di in
            try GitTagAdderImpl(
                gitCommandExecutor: di.resolve()
            )
        }
        di.register(type: GitTagDeleter.self) { di in
            try GitTagDeleterImpl(
                gitCommandExecutor: di.resolve()
            )
        }
        di.register(type: GitCommandExecutor.self) { di in
            try GitCommandExecutorImpl(
                processExecutor: di.resolve(),
                repoRootProvider: di.resolve(),
                environmentProvider: di.resolve()
            )
        }
    }
    
    private func registerCocoapods(di: DependencyRegisterer) {
        di.register(type: CocoapodsCommandExecutor.self) { di in
            try CocoapodsCommandExecutorImpl(
                bundledProcessExecutor: di.resolve()
            )
        }
        di.register(type: CocoapodsInstall.self) { di in
            try CocoapodsInstallImpl(
                cocoapodsCommandExecutor: di.resolve(),
                environmentProvider: di.resolve()
            )
        }
        di.register(type: CocoapodsSearch.self) { di in
            try CocoapodsSearchImpl(
                cocoapodsCommandExecutor: di.resolve(),
                environmentProvider: di.resolve(),
                cocoapodsSearchOutputParser: di.resolve()
            )
        }
        di.register(type: CocoapodsRepoAdd.self) { di in
            try CocoapodsRepoAddImpl(
                cocoapodsCommandExecutor: di.resolve()
            )
        }
        di.register(type: CocoapodsRepoPush.self) { di in
            try CocoapodsRepoPushImpl(
                cocoapodsCommandExecutor: di.resolve()
            )
        }
        di.register(type: CocoapodCacheClean.self) { di in
            try CocoapodCacheCleanImpl(
                cocoapodsCommandExecutor: di.resolve()
            )
        }
        di.register(type: CocoapodsTrunkCommandExecutor.self) { di in
            try CocoapodsTrunkCommandExecutorImpl(
                cocoapodsCommandExecutor: di.resolve(),
                cocoapodsTrunkTokenProvider: di.resolve(),
                environmentProvider: di.resolve()
            )
        }
        di.register(type: CocoapodsTrunkPush.self) { di in
            try CocoapodsTrunkPushImpl(
                cocoapodsTrunkCommandExecutor: di.resolve()
            )
        }
        di.register(type: CocoapodsTrunkAddOwner.self) { di in
            try CocoapodsTrunkAddOwnerImpl(
                cocoapodsTrunkCommandExecutor: di.resolve()
            )
        }
        di.register(type: CocoapodsTrunkRemoveOwner.self) { di in
            try CocoapodsTrunkRemoveOwnerImpl(
                cocoapodsTrunkCommandExecutor: di.resolve()
            )
        }
        di.register(type: CocoapodsTrunkInfoOutputParser.self) {
            CocoapodsTrunkInfoOutputParserImpl()
        }
        di.register(type: CocoapodsTrunkInfo.self) { di in
            try CocoapodsTrunkInfoImpl(
                cocoapodsTrunkCommandExecutor: di.resolve(),
                cocoapodsTrunkInfoOutputParser: di.resolve()
            )
        }
    }
    
    private func registerReleases(di: DependencyRegisterer) {
        di.register(type: BeforeReleaseTagsSetterImpl.self) { di in
            try BeforeReleaseTagsSetterImpl(
                gitTagAdder: di.resolve(),
                gitTagDeleter: di.resolve()
            )
        }
        di.register(type: BeforeReleaseTagsSetter.self) { di in
            try di.resolve() as BeforeReleaseTagsSetterImpl
        }
        di.register(type: AfterReleaseTagsSetterForExistingReleaseProvider.self) { di in
            try di.resolve() as BeforeReleaseTagsSetterImpl
        }
        di.register(type: ListOfPodspecsToPushProvider.self) { di in
            try ListOfPodspecsToPushProviderImpl(
                bundledProcessExecutor: di.resolve(),
                repoRootProvider: di.resolve()
            )
        }
        di.register(type: MixboxPodspecsPusher.self) { di in
            try MixboxPodspecsPusherImpl(
                listOfPodspecsToPushProvider: di.resolve(),
                cocoapodsTrunkPush: di.resolve(),
                repoRootProvider: di.resolve(),
                retrier: di.resolve(),
                cocoapodsTrunkInfo: di.resolve()
            )
        }
        di.register(type: MixboxPodspecsValidator.self) { di in
            try MixboxPodspecsValidatorImpl(
                repoRootProvider: di.resolve(),
                listOfPodspecsToPushProvider: di.resolve(),
                cocoapodCacheClean: di.resolve(),
                cocoapodsRepoAdd: di.resolve(),
                cocoapodsRepoPush: di.resolve(),
                environmentProvider: di.resolve(),
                podspecsPatcher: di.resolve()
            )
        }
        di.register(type: MixboxReleaseSettingsProvider.self) {
            MixboxReleaseSettingsProviderImpl()
        }
        di.register(type: RepositoryVersioningInfoProvider.self) { di in
            try RepositoryVersioningInfoProviderImpl(
                gitTagsProvider: di.resolve(),
                gitRevListProvider: di.resolve(),
                headCommitHashProvider: di.resolve()
            )
        }
        di.register(type: CurrentReleaseVersionProvider.self) { di in
            try CurrentReleaseVersionProviderImpl(
                repositoryVersioningInfoProvider: di.resolve()
            )
        }
        di.register(type: NextReleaseVersionProvider.self) { di in
            try NextReleaseVersionProviderImpl(
                repositoryVersioningInfoProvider: di.resolve()
            )
        }
        di.register(type: PodspecsPatcher.self) { di in
            try PodspecsPatcherImpl(
                repoRootProvider: di.resolve()
            )
        }
    }
    
    private func registerBash(di: DependencyRegisterer) {
        di.register(type: BashEscapedCommandMaker.self) { _ in
            BashEscapedCommandMakerImpl()
        }
        di.register(type: BashExecutor.self) { di in
            try ProcessExecutorBashExecutor(
                processExecutor: di.resolve(),
                environmentProvider: di.resolve()
            )
        }
        di.register(type: ProcessExecutor.self) { di in
            try LoggingProcessExecutor(
                originalProcessExecutor: FoundationProcessExecutor(),
                bashEscapedCommandMaker: di.resolve()
            )
        }
    }
    
    private func registerRemoteFiles(di: DependencyRegisterer) {
        di.register(type: FileUploader.self) { di in
            try FileUploaderImpl(
                fileUploaderExecutableProvider: di.resolve(),
                processExecutor: di.resolve(),
                retrier: di.resolve()
            )
        }
        di.register(type: FileDownloader.self) { di in
            try AlamofireFileDownloader(
                temporaryFileProvider: di.resolve()
            )
        }
        di.register(type: FileUploaderExecutableProvider.self) { di in
            let environmentProvider: EnvironmentProvider = try di.resolve()
            
            return try FileUploaderExecutableProviderImpl(
                temporaryFileProvider: di.resolve(),
                dataWriter: di.resolve(),
                pathDeleter: di.resolve(),
                fileUploaderExecutableBase64: environmentProvider.getOrThrow(env: Env.MIXBOX_CI_FILE_UPLOADER_BASE64_ENCODED)
            )
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func registerEmcee(di: DependencyRegisterer) {
        di.register(type: TestArgFileJsonGenerator.self) { di in
            try TestArgFileJsonGeneratorImpl(
                testArgFileGenerator: di.resolve(),
                jsonFileFromEncodableGenerator: di.resolve()
            )
        }
        di.register(type: TestArgFileGenerator.self) { di in
            try TestArgFileGeneratorImpl(
                emceeProvider: di.resolve(),
                temporaryFileProvider: di.resolve(),
                decodableFromJsonFileLoader: di.resolve(),
                emceeFileUploader: di.resolve(),
                jsonFileFromEncodableGenerator: di.resolve(),
                simulatorSettingsProvider: di.resolve(),
                developerDirProvider: di.resolve(),
                simulatorOperationTimeoutsProvider: di.resolve()
            )
        }
        di.register(type: EmceeFileUploader.self) { di in
            try EmceeFileUploaderImpl(
                fileUploader: di.resolve(),
                temporaryFileProvider: di.resolve(),
                bashExecutor: di.resolve()
            )
        }
        di.register(type: SimulatorOperationTimeoutsProvider.self) {
            DefaultSimulatorOperationTimeoutsProvider()
        }
        di.register(type: EmceeProvider.self) { di in
            try CachingEmceeProvider(
                emceeProvider: InstallingEmceeProvider(
                    temporaryFileProvider: di.resolve(),
                    processExecutor: di.resolve(),
                    emceeInstaller: di.resolve(),
                    decodableFromJsonFileLoader: di.resolve(),
                    jsonFileFromEncodableGenerator: di.resolve(),
                    simulatorSettingsProvider: di.resolve(),
                    developerDirProvider: di.resolve(),
                    remoteCacheConfigProvider: di.resolve(),
                    simulatorOperationTimeoutsProvider: di.resolve(),
                    environmentProvider: di.resolve(),
                    emceeVersionProvider: di.resolve(),
                    retrier: di.resolve(),
                    ciLogger: di.resolve()
                )
            )
        }
        di.register(type: EmceeVersionProvider.self) { _ in
            EmceeVersionProviderImpl()
        }
        di.register(type: EmceeInstaller.self) { di in
            let environmentProvider: EnvironmentProvider = try di.resolve()
            
            return EmceeInstallerImpl(
                emceeExecutablePath: try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_EMCEE_PATH)
            )
        }
    }
    
    private func registerBundler(di: DependencyRegisterer) {
        di.register(type: BundledProcessExecutor.self) { di in
            try BundledProcessExecutorImpl(
                bashExecutor: di.resolve(),
                gemfileLocationProvider: di.resolve(),
                bundlerBashCommandGenerator: di.resolve()
            )
        }
        di.register(type: GemfileLocationProvider.self) { di in
            try GemfileLocationProviderImpl(
                repoRootProvider: di.resolve(),
                gemfileBasename: "Gemfile_cocoapods"
            )
        }
    }
    
    private func registerCiFoundation(di: DependencyRegisterer) {
        di.register(type: EnvironmentProvider.self) { _ in
            // TODO: Try to remove hacks with DebugEnvironmentProvider
            
            let environmentProvider = ProcessInfoEnvironmentProvider(
                processInfo: ProcessInfo.processInfo
            )
            
            let isRunningFromXcode: Bool = ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] != nil
            
            if isRunningFromXcode {
                return DebugEnvironmentProvider(
                    originalEnvironmentProvider: environmentProvider
                )
            } else {
                return environmentProvider
            }
        }
        di.register(type: TemporaryFileProvider.self) {
            TemporaryFileProviderImpl()
        }
        di.register(type: JsonFileFromEncodableGenerator.self) { di in
            try JsonFileFromEncodableGeneratorImpl(
                temporaryFileProvider: di.resolve()
            )
        }
        di.register(type: DecodableFromJsonFileLoader.self) { _ in
            DecodableFromJsonFileLoaderImpl()
        }
        di.register(type: Retrier.self) { _ in
            RetrierImpl()
        }
        di.register(type: CiLogger.self) { _ in
            StdoutCiLogger()
        }
    }
    
    private func registerDestinations(di: DependencyRegisterer) {
        di.register(type: MixboxTestDestinationConfigurationsProvider.self) { di in
            let environmentProvider: EnvironmentProvider = try di.resolve()
            
            return try MixboxTestDestinationConfigurationsProviderImpl(
                decodableFromJsonFileLoader: di.resolve(),
                destinationFileBaseName: environmentProvider.getOrThrow(env: Env.MIXBOX_CI_DESTINATION),
                repoRootProvider: di.resolve()
            )
        }
        di.register(type: MixboxTestDestinationProvider.self) { di in
            try MixboxTestDestinationProviderImpl(
                mixboxTestDestinationConfigurationsProvider: di.resolve()
            )
        }
    }
    
    private func registerXcodebuild(di: DependencyRegisterer) {
        di.register(type: Xcodebuild.self) { di in
            try XcodebuildImpl(
                processExecutor: di.resolve(),
                derivedDataPathProvider: di.resolve(),
                cocoapodsInstall: di.resolve(),
                repoRootProvider: di.resolve(),
                environmentProvider: di.resolve(),
                ciLogger: di.resolve()
            )
        }
        di.register(type: IosProjectBuilder.self) { di in
            try IosProjectBuilderImpl(
                xcodebuild: di.resolve(),
                simctlList: di.resolve(),
                simctlBoot: di.resolve(),
                simctlShutdown: di.resolve(),
                simctlCreate: di.resolve()
            )
        }
        di.register(type: MacosProjectBuilder.self) { di in
            try MacosProjectBuilderImpl(
                xcodebuild: di.resolve()
            )
        }
        di.register(type: DerivedDataPathProvider.self) { di in
            try DerivedDataPathProviderImpl(
                temporaryFileProvider: di.resolve()
            )
        }
    }
    
    private func registerSimctl(di: DependencyRegisterer) {
        di.register(type: SimctlExecutor.self) { di in
            try SimctlExecutorImpl(
                processExecutor: di.resolve(),
                environmentProvider: di.resolve()
            )
        }
        di.register(type: SimctlList.self) { di in
            try SimctlListImpl(
                simctlExecutor: di.resolve()
            )
        }
        di.register(type: SimctlBoot.self) { di in
            try SimctlBootImpl(
                simctlExecutor: di.resolve()
            )
        }
        di.register(type: SimctlShutdown.self) { di in
            try SimctlShutdownImpl(
                simctlExecutor: di.resolve()
            )
        }
        di.register(type: SimctlCreate.self) { di in
            try SimctlCreateImpl(
                simctlExecutor: di.resolve()
            )
        }
    }
    
    private func registerTestRunning(di: DependencyRegisterer) {
        di.register(type: TestsTaskRunner.self) { di in
            try TestsTaskRunnerImpl(
                testRunner: di.resolve(),
                mixboxTestDestinationConfigurationsProvider: di.resolve(),
                iosProjectBuilder: di.resolve(),
                iosBuildArtifactsProviderFactory: di.resolve()
            )
        }
        di.register(type: IosBuildArtifactsProviderFactory.self) { _ in
            IosBuildArtifactsProviderFactoryImpl(
                testDiscoveryMode: .parseFunctionSymbols
            )
        }
    }
}
