import MixboxIpcCommon
import MixboxIpc
import Foundation
import XCTest

extension XCUIElement {
    public var enhancedAccessibilityLabel: EnhancedAccessibilityLabel? {
        return EnhancedAccessibilityLabel.fromAccessibilityLabel(label)
    }
    
    public var originalAccessibilityLabel: String {
        let originalAccessibilityLabel = EnhancedAccessibilityLabel.originalAccessibilityLabel(accessibilityLabel: label)
        let xctestLabelValueIfAccessibilityLabelIsNil = ""
        
        return originalAccessibilityLabel ?? xctestLabelValueIfAccessibilityLabelIsNil
    }
    
    public var isDefinitelyHidden: Bool {
        guard let enhancedAccessibilityLabel = enhancedAccessibilityLabel else {
            return false
        }
        return enhancedAccessibilityLabel.isDefinitelyHidden
    }
    
    public func percentageOfVisibleArea(ipcClient: IpcClient) -> CGFloat? {
        guard let enhancedAccessibilityLabel = enhancedAccessibilityLabel else {
            return nil
        }
        
        let result = ipcClient.call(
            method: PercentageOfVisibleAreaIpcMethod(),
            arguments: enhancedAccessibilityLabel.uniqueIdentifier
        )
        
        // TODO: Replace nil with 0 in PercentageOfVisibleAreaIpcMethodHandler?
        return (result.data ?? .none) ?? 0
    }
    
    public var center: XCUICoordinate {
        return coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
    }
}
