import MixboxIpcCommon
import MixboxIpc
import MixboxUiKit

public final class ElementVisibilityCheckerImpl: ElementVisibilityChecker {
    private let ipcClient: IpcClient
    
    public init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    // MARK: - ElementVisibilityChecker
    
    private final class VisibilityPercentage {
        static let probablyVisible: CGFloat = 1.0
        static let probablyHidden: CGFloat = 0.0
        static let definitelyHidden: CGFloat = 0.0
    }
    
    public func percentageOfVisibleArea(snapshot: ElementSnapshot) -> CGFloat {
        if let isDefinitelyHidden = snapshot.isDefinitelyHidden.valueIfAvailable, isDefinitelyHidden {
            return VisibilityPercentage.definitelyHidden
        }
        
        var parentPointer = snapshot.parent
        var lastParent = snapshot.parent
        
        while let parent = parentPointer {
            lastParent = parent
            parentPointer = parent.parent
        }
        if let topSnapshotFrame = lastParent?.frameRelativeToScreen {
            if !topSnapshotFrame.intersects(snapshot.frameRelativeToScreen) {
                return VisibilityPercentage.definitelyHidden
            }
        }

        if snapshot.frameRelativeToScreen.mb_hasZeroArea() {
            return VisibilityPercentage.definitelyHidden
        }
        
        if let percentageOfVisibleArea = percentageOfVisibleAreaFromIpcClient(snapshot: snapshot) {
            return percentageOfVisibleArea
        }
        
        return VisibilityPercentage.probablyVisible
    }
    
    public func percentageOfVisibleArea(elementUniqueIdentifier: String) -> CGFloat {
        return percentageOfVisibleAreaFromIpcClient(elementUniqueIdentifier: elementUniqueIdentifier)
    }
    
    // MARK: - Private
    
    private func percentageOfVisibleAreaFromIpcClient(snapshot: ElementSnapshot) -> CGFloat? {
        guard let uniqueIdentifier = snapshot.uniqueIdentifier.valueIfAvailable else {
            return nil
        }
        
        return percentageOfVisibleAreaFromIpcClient(elementUniqueIdentifier: uniqueIdentifier)
    }
    
    private func percentageOfVisibleAreaFromIpcClient(elementUniqueIdentifier: String) -> CGFloat {
        let result = ipcClient.call(
            method: PercentageOfVisibleAreaIpcMethod(),
            arguments: elementUniqueIdentifier
        )
        
        // TODO: Replace nil with 0 in PercentageOfVisibleAreaIpcMethodHandler?
        return (result.data ?? .none) ?? 0
    }
}
