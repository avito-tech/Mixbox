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

// TODO: Fix retain-cycle in DI. Container retains itself.
open class CommonDi: BaseDi {
    // swiftlint:disable:next function_body_length
    override open func registerAll(container: DependencyContainer) {
        container.register(type: RepoRootProvider.self) {
            RepoRootProviderImpl()
        }
        container.register(type: BashExecutor.self) {
            ProcessExecutorBashExecutor(
                processExecutor: try container.resolve(),
                environmentProvider: try container.resolve()
            )
        }
        container.register(type: ProcessExecutor.self) {
            LoggingProcessExecutor(
                originalProcessExecutor: FoundationProcessExecutor()
            )
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
        container.register(type: EmceeProvider.self) {
            CachingEmceeProvider(
                emceeProvider: InstallingEmceeProvider(
                    temporaryFileProvider: try container.resolve(),
                    processExecutor: try container.resolve(),
                    emceeInstaller: try container.resolve(),
                    decodableFromJsonFileLoader: try container.resolve()
                )
            )
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
        container.register(type: FileUploader.self) {
            FileUploaderImpl(
                fileUploaderExecutableProvider: try container.resolve(),
                processExecutor: try container.resolve()
            )
        }
        container.register(type: Brew.self) {
            BrewImpl(bashExecutor: try container.resolve())
        }
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
                jsonFileFromEncodableGenerator: try container.resolve()
            )
        }
        container.register(type: EmceeFileUploader.self) {
            EmceeFileUploaderImpl(
                fileUploader: try container.resolve(),
                temporaryFileProvider: try container.resolve(),
                bashExecutor: try container.resolve()
            )
        }
        container.register(type: GemfileLocationProvider.self) {
            GemfileLocationProviderImpl(
                repoRootProvider: try container.resolve(),
                gemfileBasename: "Gemfile_cocoapods_1_8_4"
            )
        }
        container.register(type: CocoapodsFactory.self) {
            CocoapodsFactoryImpl(
                bashExecutor: try container.resolve(),
                bundlerCommandGenerator: try container.resolve()
            )
        }
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
        container.register(type: DerivedDataPathProvider.self) {
            DerivedDataPathProviderImpl(
                temporaryFileProvider: try container.resolve()
            )
        }
        container.register(type: CocoapodsFactory.self) {
            CocoapodsFactoryImpl(
                bashExecutor: try container.resolve(),
                bundlerCommandGenerator: try container.resolve()
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
        container.register(type: Xcodebuild.self) {
            XcodebuildImpl(
                bashExecutor: try container.resolve(),
                derivedDataPathProvider: try container.resolve(),
                cocoapodsFactory: try container.resolve(),
                repoRootProvider: try container.resolve(),
                environmentProvider: try container.resolve()
            )
        }
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
        container.register(type: MacosProjectBuilder.self) {
            MacosProjectBuilderImpl(
                xcodebuild: try container.resolve()
            )
        }
        container.register(type: BundlerCommandGenerator.self) {
            BundlerCommandGeneratorImpl(
                bashExecutor: try container.resolve(),
                gemfileLocationProvider: try container.resolve()
            )
        }
    }
}
