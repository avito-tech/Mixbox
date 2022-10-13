import MixboxFoundation
import MixboxTestsFoundation
import MixboxIpc
import MixboxIpcCommon

public final class IpcUiKitHierarchyElementFinder: ElementFinder {
    private let ipcClient: SynchronousIpcClient
    private let performanceLogger: PerformanceLogger
    private let resolvedElementQueryLogger: ResolvedElementQueryLogger
    
    public init(
        ipcClient: SynchronousIpcClient,
        performanceLogger: PerformanceLogger,
        resolvedElementQueryLogger: ResolvedElementQueryLogger)
    {
        self.ipcClient = ipcClient
        self.performanceLogger = performanceLogger
        self.resolvedElementQueryLogger = resolvedElementQueryLogger
    }
    
    public func query(
        elementMatcher: ElementMatcher,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation)
        -> ElementQuery
    {
        return IpcUiKitHierarchyElementQuery(
            ipcClient: ipcClient,
            elementMatcher: elementMatcher,
            performanceLogger: performanceLogger,
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation,
            resolvedElementQueryLogger: resolvedElementQueryLogger
        )
    }
}
