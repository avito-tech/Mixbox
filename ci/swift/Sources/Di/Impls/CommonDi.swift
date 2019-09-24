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
            EmceeInstallerImpl(
                brew: try container.resolve(),
                fileDownloader: try container.resolve(),
                bashExecutor: try container.resolve(),
                emceeExecutableUrl: try Env.MIXBOX_CI_EMCEE_URL.getUrlOrThrow() // FIXME
            )
        }
        container.register(type: FileDownloader.self) {
            AlamofireFileDownloader(
                temporaryFileProvider: try container.resolve()
            )
        }
        container.register(type: FileUploaderExecutableProvider.self) {
            CachingFileUploaderExecutableProvider(
                fileUploaderExecutableProvider: DownloadingFileUploaderExecutableProvider(
                    fileDownloader: try container.resolve(),
                    fileUploaderUrl: try URL.from(string: try Env.MIXBOX_CI_FILE_UPLOADER_URL.getOrThrow())
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
            EmceeFileUploaderImpl(fileUploader: try container.resolve())
        }
        
        // FIXME:
        container.register(type: EnvironmentProvider.self) {
            EnvironmentSingletons.environmentProvider
        }
    }
}
