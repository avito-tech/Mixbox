import MixboxIpcCommon
import MixboxIpc

public final class IpcViewHierarchyProvider: ViewHierarchyProvider {
    private let synchronousIpcClient: SynchronousIpcClient
    
    public init(
        synchronousIpcClient: SynchronousIpcClient
    ) {
        self.synchronousIpcClient = synchronousIpcClient
    }
    
    public func viewHierarchy() throws -> ViewHierarchy {
        try synchronousIpcClient.callOrThrow(
            method: ViewHierarchyIpcMethod()
        ).getReturnValue()
    }
}
