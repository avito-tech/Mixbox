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

open class CommonDi: BaseDi {
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
        container.register(type: EmceeProvider.self) {
            EmceeProviderImpl(
                temporaryFileProvider: try container.resolve(),
                processExecutor: try container.resolve(),
                emceeInstaller: try container.resolve(),
                runtimeDumpFileLoader: try container.resolve()
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
            BashFileDownloader(
                temporaryFileProvider: try container.resolve(),
                bashExecutor: try container.resolve()
            )
        }
        container.register(type: RuntimeDumpFileLoader.self) {
            RuntimeDumpFileLoaderImpl()
        }
        container.register(type: Brew.self) {
            BrewImpl(bashExecutor: try container.resolve())
        }
        
        // FIXME:
        container.register(type: EnvironmentProvider.self) {
            EnvironmentSingletons.environmentProvider
        }
    }
}
