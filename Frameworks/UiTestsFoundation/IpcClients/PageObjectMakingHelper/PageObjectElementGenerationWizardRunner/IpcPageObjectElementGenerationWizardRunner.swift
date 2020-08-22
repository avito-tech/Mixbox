import MixboxIpcCommon
import MixboxIpc

public final class IpcPageObjectElementGenerationWizardRunner: PageObjectElementGenerationWizardRunner {
    private let synchronousIpcClient: SynchronousIpcClient
    
    public init(synchronousIpcClient: SynchronousIpcClient) {
        self.synchronousIpcClient = synchronousIpcClient
    }
    
    public func run() throws {
        _ = try synchronousIpcClient.callOrThrow(
            method: RunPageObjectElementGenerationWizardIpcMethod(),
            arguments: IpcVoid()
        )
    }
}
