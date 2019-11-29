import CiFoundation
import Bash

public final class InstallingEmceeProvider: EmceeProvider {
    private let temporaryFileProvider: TemporaryFileProvider
    private let processExecutor: ProcessExecutor
    private let emceeInstaller: EmceeInstaller
    private let decodableFromJsonFileLoader: DecodableFromJsonFileLoader
    private let jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        processExecutor: ProcessExecutor,
        emceeInstaller: EmceeInstaller,
        decodableFromJsonFileLoader: DecodableFromJsonFileLoader,
        jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator)
    {
        self.temporaryFileProvider = temporaryFileProvider
        self.processExecutor = processExecutor
        self.emceeInstaller = emceeInstaller
        self.decodableFromJsonFileLoader = decodableFromJsonFileLoader
        self.jsonFileFromEncodableGenerator = jsonFileFromEncodableGenerator
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
                jsonFileFromEncodableGenerator: jsonFileFromEncodableGenerator
            ),
            emceeRunTestsOnRemoteQueueCommand: EmceeRunTestsOnRemoteQueueCommandImpl(
                emceeExecutable: emceeExecutable
            )
        )
    }
}
