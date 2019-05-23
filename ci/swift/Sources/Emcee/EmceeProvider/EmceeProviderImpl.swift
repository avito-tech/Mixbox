import CiFoundation
import Bash

public final class EmceeProviderImpl: EmceeProvider {
    private let temporaryFileProvider: TemporaryFileProvider
    private let processExecutor: ProcessExecutor
    private let emceeInstaller: EmceeInstaller
    private let runtimeDumpFileLoader: RuntimeDumpFileLoader
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        processExecutor: ProcessExecutor,
        emceeInstaller: EmceeInstaller,
        runtimeDumpFileLoader: RuntimeDumpFileLoader)
    {
        self.temporaryFileProvider = temporaryFileProvider
        self.processExecutor = processExecutor
        self.emceeInstaller = emceeInstaller
        self.runtimeDumpFileLoader = runtimeDumpFileLoader
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
                runtimeDumpFileLoader: runtimeDumpFileLoader
            ),
            emceeRunTestsOnRemoteQueueCommand: EmceeRunTestsOnRemoteQueueCommandImpl(
                emceeExecutable: emceeExecutable
            )
        )
    }
}
