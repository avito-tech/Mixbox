import MixboxIpcClients
import MixboxIpcCommon
import MixboxIpc
import MixboxUiTestsFoundation

protocol ElementVisibilityChecker {
    func percentageOfVisibleArea(snapshot: ElementSnapshot) -> CGFloat
    func percentageOfVisibleArea(elementUniqueIdentifier: String) -> CGFloat
}

final class ElementVisibilityCheckerImpl: ElementVisibilityChecker {
    private let ipcClient: IpcClient
    
    init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    // MARK: - ElementVisibilityChecker
    
    private final class VisibilityPercentage {
        static let probablyVisible: CGFloat = 1.0
        static let probablyHidden: CGFloat = 0.0
        static let definitelyHidden: CGFloat = 0.0
    }
    
    func percentageOfVisibleArea(snapshot: ElementSnapshot) -> CGFloat {
        if let isDefinitelyHidden = snapshot.isDefinitelyHidden.value, isDefinitelyHidden {
            return VisibilityPercentage.definitelyHidden
        }
        
        var parentPointer = snapshot.parent
        while let parent = parentPointer {
            parentPointer = parent.parent
        }
        if let topSnapshotFrame = parentPointer?.frameOnScreen {
            if !topSnapshotFrame.intersects(snapshot.frameOnScreen) {
                return VisibilityPercentage.definitelyHidden
            }
        }
        
        if let percentageOfVisibleArea = snapshot.percentageOfVisibleArea(ipcClient: ipcClient) {
            return percentageOfVisibleArea
        }
        
        return VisibilityPercentage.probablyVisible
    }
    
    func percentageOfVisibleArea(elementUniqueIdentifier: String) -> CGFloat {
        let result = ipcClient.call(
            method: PercentageOfVisibleAreaIpcMethod(),
            arguments: elementUniqueIdentifier
        )
        
        // TODO: Replace nil with 0 in PercentageOfVisibleAreaIpcMethodHandler?
        return (result.data ?? .none) ?? 0
    }
}
