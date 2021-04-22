import CiFoundation
import Bash

public final class InstallingEmceeProvider: EmceeProvider {
    private let temporaryFileProvider: TemporaryFileProvider
    private let processExecutor: ProcessExecutor
    private let emceeInstaller: EmceeInstaller
    private let decodableFromJsonFileLoader: DecodableFromJsonFileLoader
    private let jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator
    private let simulatorSettingsProvider: SimulatorSettingsProvider
    private let developerDirProvider: DeveloperDirProvider
    private let remoteCacheConfigProvider: RemoteCacheConfigProvider
    private let simulatorOperationTimeoutsProvider: SimulatorOperationTimeoutsProvider
    private let environmentProvider: EnvironmentProvider
    private let emceeVersionProvider: EmceeVersionProvider
    private let retrier: Retrier
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        processExecutor: ProcessExecutor,
        emceeInstaller: EmceeInstaller,
        decodableFromJsonFileLoader: DecodableFromJsonFileLoader,
        jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator,
        simulatorSettingsProvider: SimulatorSettingsProvider,
        developerDirProvider: DeveloperDirProvider,
        remoteCacheConfigProvider: RemoteCacheConfigProvider,
        simulatorOperationTimeoutsProvider: SimulatorOperationTimeoutsProvider,
        environmentProvider: EnvironmentProvider,
        emceeVersionProvider: EmceeVersionProvider,
        retrier: Retrier)
    {
        self.temporaryFileProvider = temporaryFileProvider
        self.processExecutor = processExecutor
        self.emceeInstaller = emceeInstaller
        self.decodableFromJsonFileLoader = decodableFromJsonFileLoader
        self.jsonFileFromEncodableGenerator = jsonFileFromEncodableGenerator
        self.simulatorSettingsProvider = simulatorSettingsProvider
        self.developerDirProvider = developerDirProvider
        self.remoteCacheConfigProvider = remoteCacheConfigProvider
        self.simulatorOperationTimeoutsProvider = simulatorOperationTimeoutsProvider
        self.environmentProvider = environmentProvider
        self.emceeVersionProvider = emceeVersionProvider
        self.retrier = retrier
    }
    
    public func emcee() throws -> Emcee {
        let emceeExecutable = EmceeExecutableImpl(
            processExecutor: processExecutor,
            executablePath: try emceeInstaller.installEmcee()
        )
        
        return DelegatingEmcee(
            emceeDumpCommand: EmceeDumpCommandImpl(
                temporaryFileProvider: temporaryFileProvider,
                emceeExecutable: emceeExecutable,
                decodableFromJsonFileLoader: decodableFromJsonFileLoader,
                jsonFileFromEncodableGenerator: jsonFileFromEncodableGenerator,
                simulatorSettingsProvider: simulatorSettingsProvider,
                developerDirProvider: developerDirProvider,
                remoteCacheConfigProvider: remoteCacheConfigProvider,
                simulatorOperationTimeoutsProvider: simulatorOperationTimeoutsProvider,
                environmentProvider: environmentProvider,
                emceeVersionProvider: emceeVersionProvider,
                retrier: retrier
            ),
            emceeRunTestsOnRemoteQueueCommand: EmceeRunTestsOnRemoteQueueCommandImpl(
                emceeExecutable: emceeExecutable,
                remoteCacheConfigProvider: remoteCacheConfigProvider,
                emceeVersionProvider: emceeVersionProvider,
                retrier: retrier
            )
        )
    }
}
