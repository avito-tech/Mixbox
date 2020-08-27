import MixboxIpcCommon
import MixboxIpc

public final class IpcPageObjectElementGenerationWizardRunner: SynchronousPageObjectElementGenerationWizardRunner {
    private let synchronousIpcClient: SynchronousIpcClient
    
    public init(synchronousIpcClient: SynchronousIpcClient) {
        self.synchronousIpcClient = synchronousIpcClient
    }
    
    public func run() throws {
        let result = try synchronousIpcClient.callOrThrow(
            method: RunPageObjectElementGenerationWizardIpcMethod(),
            arguments: IpcVoid()
        )
        try result.getVoidReturnValue()
    }
}
