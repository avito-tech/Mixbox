import Dip
import Bash
import CiFoundation
import Tasks
import Cocoapods
import Git
import Simctl
import Foundation
import Emcee
import SingletonHell
import Brew
import RemoteFiles
import Xcodebuild
import Destinations
import Bundler
import Releases

// TODO: Fix retain-cycle in DI. Container retains itself.
// TODO: Split this. Put code in frameworks. `MixboxDi` will allow to do this neatly (now we use `Dip` here).
// swiftlint:disable file_length function_body_length type_body_length
open class CommonDi: BaseDi {
    override open func registerAll(container: DependencyContainer) {
        registerGit(container: container)
        registerCocoapods(container: container)
        registerReleases(container: container)
        registerBash(container: container)
        registerRemoteFiles(container: container)
        registerBrew(container: container)
        registerEmcee(container: container)
        registerBundler(container: container)
        registerCiFoundation(container: container)
        registerDestinations(container: container)
        registerXcodebuild(container: container)
        registerSimctl(container: container)
    }
    
    private func registerGit(container: DependencyContainer) {
        container.register(type: RepoRootProvider.self) {
            RepoRootProviderImpl()
        }
        container.register(type: GitTagsProvider.self) {
            GitTagsProviderImpl(
                gitCommandExecutor: try container.resolve()
            )
        }
        container.register(type: GitRevListProvider.self) {
            GitRevListProviderImpl(
                gitCommandExecutor: try container.resolve()
            )
        }
        container.register(type: HeadCommitHashProvider.self) {
            HeadCommitHashProviderImpl(
                gitCommandExecutor: try container.resolve()
            )
        }
        container.register(type: GitTagAdder.self) {
            GitTagAdderImpl(
                gitCommandExecutor: try container.resolve()
            )
        }
        container.register(type: GitTagDeleter.self) {
            GitTagDeleterImpl(
                gitCommandExecutor: try container.resolve()
            )
        }
        container.register(type: GitCommandExecutor.self) {
            GitCommandExecutorImpl(
                processExecutor: try container.resolve(),
                repoRootProvider: try container.resolve(),
                environmentProvider: try container.resolve()
            )
        }
    }
    
    private func registerCocoapods(container: DependencyContainer) {
        container.register(type: CocoapodsCommandExecutor.self) {
            CocoapodsCommandExecutorImpl(
                bundledProcessExecutor: try container.resolve()
            )
        }
        container.register(type: CocoapodsInstall.self) {
            CocoapodsInstallImpl(
                cocoapodsCommandExecutor: try container.resolve(),
                environmentProvider: try container.resolve()
            )
        }
        container.register(type: CocoapodsSearch.self) {
            CocoapodsSearchImpl(
                cocoapodsCommandExecutor: try container.resolve(),
                environmentProvider: try container.resolve(),
                cocoapodsSearchOutputParser: try container.resolve()
            )
        }
        container.register(type: CocoapodsRepoAdd.self) {
            CocoapodsRepoAddImpl(
                cocoapodsCommandExecutor: try container.resolve()
            )
        }
        container.register(type: CocoapodsRepoPush.self) {
            CocoapodsRepoPushImpl(
                cocoapodsCommandExecutor: try container.resolve()
            )
        }
        container.register(type: CocoapodCacheClean.self) {
            CocoapodCacheCleanImpl(
                cocoapodsCommandExecutor: try container.resolve()
            )
        }
        container.register(type: CocoapodsTrunkCommandExecutor.self) {
            CocoapodsTrunkCommandExecutorImpl(
                cocoapodsCommandExecutor: try container.resolve(),
                cocoapodsTrunkTokenProvider: try container.resolve(),
                environmentProvider: try container.resolve()
            )
        }
        container.register(type: CocoapodsTrunkPush.self) {
            CocoapodsTrunkPushImpl(
                cocoapodsTrunkCommandExecutor: try container.resolve()
            )
        }
        container.register(type: CocoapodsTrunkAddOwner.self) {
            CocoapodsTrunkAddOwnerImpl(
                cocoapodsTrunkCommandExecutor: try container.resolve()
            )
        }
        container.register(type: CocoapodsTrunkRemoveOwner.self) {
            CocoapodsTrunkRemoveOwnerImpl(
                cocoapodsTrunkCommandExecutor: try container.resolve()
            )
        }
        container.register(type: CocoapodsTrunkInfoOutputParser.self) {
            CocoapodsTrunkInfoOutputParserImpl()
        }
        container.register(type: CocoapodsTrunkInfo.self) {
            CocoapodsTrunkInfoImpl(
                cocoapodsTrunkCommandExecutor: try container.resolve(),
                cocoapodsTrunkInfoOutputParser: try container.resolve()
            )
        }
    }
    
    private func registerReleases(container: DependencyContainer) {
        container.register(type: BeforeReleaseTagsSetterImpl.self) {
            BeforeReleaseTagsSetterImpl(
                gitTagAdder: try container.resolve(),
                gitTagDeleter: try container.resolve()
            )
        }
        container.register(type: BeforeReleaseTagsSetter.self) {
            try container.resolve() as BeforeReleaseTagsSetterImpl
        }
        container.register(type: AfterReleaseTagsSetterForExistingReleaseProvider.self) {
            try container.resolve() as BeforeReleaseTagsSetterImpl
        }
        container.register(type: ListOfPodspecsToPushProvider.self) {
            ListOfPodspecsToPushProviderImpl(
                bundledProcessExecutor: try container.resolve(),
                repoRootProvider: try container.resolve()
            )
        }
        container.register(type: MixboxPodspecsPusher.self) {
            MixboxPodspecsPusherImpl(
                listOfPodspecsToPushProvider: try container.resolve(),
                cocoapodsTrunkPush: try container.resolve(),
                repoRootProvider: try container.resolve(),
                retrier: try container.resolve(),
                cocoapodsTrunkInfo: try container.resolve()
            )
        }
        container.register(type: MixboxPodspecsValidator.self) {
            MixboxPodspecsValidatorImpl(
                repoRootProvider: try container.resolve(),
                listOfPodspecsToPushProvider: try container.resolve(),
                cocoapodCacheClean: try container.resolve(),
                cocoapodsRepoAdd: try container.resolve(),
                cocoapodsRepoPush: try container.resolve(),
                environmentProvider: try container.resolve(),
                podspecsPatcher: try container.resolve()
            )
        }
        container.register(type: MixboxReleaseSettingsProvider.self) {
            MixboxReleaseSettingsProviderImpl()
        }
        container.register(type: RepositoryVersioningInfoProvider.self) {
            RepositoryVersioningInfoProviderImpl(
                gitTagsProvider: try container.resolve(),
                gitRevListProvider: try container.resolve(),
                headCommitHashProvider: try container.resolve()
            )
        }
        container.register(type: CurrentReleaseVersionProvider.self) {
            CurrentReleaseVersionProviderImpl(
                repositoryVersioningInfoProvider: try container.resolve()
            )
        }
        container.register(type: NextReleaseVersionProvider.self) {
            NextReleaseVersionProviderImpl(
                repositoryVersioningInfoProvider: try container.resolve()
            )
        }
        container.register(type: PodspecsPatcher.self) {
            PodspecsPatcherImpl(
                repoRootProvider: try container.resolve()
            )
        }
    }
    
    private func registerBash(container: DependencyContainer) {
        container.register(type: BashEscapedCommandMaker.self) {
            BashEscapedCommandMakerImpl()
        }
        container.register(type: BashExecutor.self) {
            ProcessExecutorBashExecutor(
                processExecutor: try container.resolve(),
                environmentProvider: try container.resolve()
            )
        }
        container.register(type: ProcessExecutor.self) {
            LoggingProcessExecutor(
                originalProcessExecutor: FoundationProcessExecutor(),
                bashEscapedCommandMaker: try container.resolve()
            )
        }
    }
    
    private func registerRemoteFiles(container: DependencyContainer) {
        container.register(type: FileUploader.self) {
            FileUploaderImpl(
                fileUploaderExecutableProvider: try container.resolve(),
                processExecutor: try container.resolve()
            )
        }
        container.register(type: FileDownloader.self) {
            AlamofireFileDownloader(
                temporaryFileProvider: try container.resolve()
            )
        }
        container.register(type: FileUploaderExecutableProvider.self) {
            let environmentProvider: EnvironmentProvider = try container.resolve()
            
            return CachingFileUploaderExecutableProvider(
                fileUploaderExecutableProvider: DownloadingFileUploaderExecutableProvider(
                    fileDownloader: try container.resolve(),
                    fileUploaderUrl: try URL.from(
                        string: try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_FILE_UPLOADER_URL)
                    )
                )
            )
        }
    }
    
    private func registerBrew(container: DependencyContainer) {
        container.register(type: Brew.self) {
            BrewImpl(bashExecutor: try container.resolve())
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func registerEmcee(container: DependencyContainer) {
        container.register(type: TestArgFileJsonGenerator.self) {
            TestArgFileJsonGeneratorImpl(
                testArgFileGenerator: try container.resolve(),
                jsonFileFromEncodableGenerator: try container.resolve()
            )
        }
        container.register(type: TestArgFileGenerator.self) {
            TestArgFileGeneratorImpl(
                emceeProvider: try container.resolve(),
                temporaryFileProvider: try container.resolve(),
                decodableFromJsonFileLoader: try container.resolve(),
                emceeFileUploader: try container.resolve(),
                jsonFileFromEncodableGenerator: try container.resolve(),
                simulatorSettingsProvider: try container.resolve(),
                developerDirProvider: try container.resolve(),
                simulatorOperationTimeoutsProvider: try container.resolve()
            )
        }
        container.register(type: EmceeFileUploader.self) {
            EmceeFileUploaderImpl(
                fileUploader: try container.resolve(),
                temporaryFileProvider: try container.resolve(),
                bashExecutor: try container.resolve()
            )
        }
        container.register(type: SimulatorOperationTimeoutsProvider.self) {
            DefaultSimulatorOperationTimeoutsProvider()
        }
        container.register(type: EmceeProvider.self) {
            CachingEmceeProvider(
                emceeProvider: InstallingEmceeProvider(
                    temporaryFileProvider: try container.resolve(),
                    processExecutor: try container.resolve(),
                    emceeInstaller: try container.resolve(),
                    decodableFromJsonFileLoader: try container.resolve(),
                    jsonFileFromEncodableGenerator: try container.resolve(),
                    simulatorSettingsProvider: try container.resolve(),
                    developerDirProvider: try container.resolve(),
                    remoteCacheConfigProvider: try container.resolve(),
                    simulatorOperationTimeoutsProvider: try container.resolve(),
                    environmentProvider: try container.resolve(),
                    emceeVersionProvider: try container.resolve(),
                    retrier: try container.resolve()
                )
            )
        }
        container.register(type: EmceeVersionProvider.self) {
            EmceeVersionProviderImpl()
        }
        container.register(type: EmceeInstaller.self) {
            let environmentProvider: EnvironmentProvider = try container.resolve()
            
            return EmceeInstallerImpl(
                brew: try container.resolve(),
                fileDownloader: try container.resolve(),
                bashExecutor: try container.resolve(),
                emceeExecutableUrl: try environmentProvider.getUrlOrThrow(env: Env.MIXBOX_CI_EMCEE_URL) // FIXME
            )
        }
    }
    
    private func registerBundler(container: DependencyContainer) {
        container.register(type: BundledProcessExecutor.self) {
            BundledProcessExecutorImpl(
                bashExecutor: try container.resolve(),
                gemfileLocationProvider: try container.resolve(),
                bundlerBashCommandGenerator: try container.resolve()
            )
        }
        container.register(type: GemfileLocationProvider.self) {
            GemfileLocationProviderImpl(
                repoRootProvider: try container.resolve(),
                gemfileBasename: "Gemfile_cocoapods"
            )
        }
    }
    
    private func registerCiFoundation(container: DependencyContainer) {
        container.register(type: EnvironmentProvider.self) {
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
        container.register(type: TemporaryFileProvider.self) {
            TemporaryFileProviderImpl()
        }
        container.register(type: JsonFileFromEncodableGenerator.self) {
            JsonFileFromEncodableGeneratorImpl(
                temporaryFileProvider: try container.resolve()
            )
        }
        container.register(type: DecodableFromJsonFileLoader.self) {
            DecodableFromJsonFileLoaderImpl()
        }
        container.register(type: Retrier.self) {
            RetrierImpl()
        }
    }
    
    private func registerDestinations(container: DependencyContainer) {
        container.register(type: MixboxTestDestinationConfigurationsProvider.self) {
            let environmentProvider: EnvironmentProvider = try container.resolve()
            
            return MixboxTestDestinationConfigurationsProviderImpl(
                decodableFromJsonFileLoader: try container.resolve(),
                destinationFileBaseName: try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_DESTINATION),
                repoRootProvider: try container.resolve()
            )
        }
        container.register(type: MixboxTestDestinationProvider.self) {
            MixboxTestDestinationProviderImpl(
                mixboxTestDestinationConfigurationsProvider: try container.resolve()
            )
        }
    }
    
    private func registerXcodebuild(container: DependencyContainer) {
        container.register(type: Xcodebuild.self) {
            XcodebuildImpl(
                bashExecutor: try container.resolve(),
                derivedDataPathProvider: try container.resolve(),
                cocoapodsInstall: try container.resolve(),
                repoRootProvider: try container.resolve(),
                environmentProvider: try container.resolve()
            )
        }
        container.register(type: IosProjectBuilder.self) {
            IosProjectBuilderImpl(
                xcodebuild: try container.resolve(),
                simctlList: try container.resolve(),
                simctlBoot: try container.resolve(),
                simctlShutdown: try container.resolve(),
                simctlCreate: try container.resolve()
            )
        }
        container.register(type: MacosProjectBuilder.self) {
            MacosProjectBuilderImpl(
                xcodebuild: try container.resolve()
            )
        }
        container.register(type: DerivedDataPathProvider.self) {
            DerivedDataPathProviderImpl(
                temporaryFileProvider: try container.resolve()
            )
        }
    }
    
    private func registerSimctl(container: DependencyContainer) {
        container.register(type: SimctlList.self) {
            SimctlListImpl(
                bashExecutor: try container.resolve(),
                temporaryFileProvider: try container.resolve()
            )
        }
        container.register(type: SimctlBoot.self) {
            SimctlBootImpl(
                bashExecutor: try container.resolve()
            )
        }
        container.register(type: SimctlShutdown.self) {
            SimctlShutdownImpl(
                bashExecutor: try container.resolve()
            )
        }
        container.register(type: SimctlCreate.self) {
            SimctlCreateImpl(
                bashExecutor: try container.resolve()
            )
        }
    }
}
