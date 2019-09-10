import MixboxIpcCommon
import MixboxIpc
import Foundation
import XCTest

extension XCUIElement {
    
    public var enhancedAccessibilityValueStringRepresentation: String? {
        return self.value as? String
    }
    
    public var enhancedAccessibilityValue: EnhancedAccessibilityValue? {
        return EnhancedAccessibilityValue.fromAccessibilityValue(self.enhancedAccessibilityValueStringRepresentation)
    }
    
    public var originalAccessibilityValue: String? {
        if let enhancedAccessibilityValue = enhancedAccessibilityValue {
            return enhancedAccessibilityValue.originalAccessibilityValue
        } else {
            return value as? String
        }
    }
    
    public var isDefinitelyHidden: Bool {
        guard let enhancedAccessibilityValue = enhancedAccessibilityValue else {
            return false
        }
        return enhancedAccessibilityValue.isDefinitelyHidden
    }
    
    public var hostDefinedValues: [String: String] {
        guard let enhancedAccessibilityValue = enhancedAccessibilityValue else {
            return [:]
        }
        return enhancedAccessibilityValue.customValues
    }
    
    public func percentageOfVisibleArea(ipcClient: IpcClient) -> CGFloat? {
        guard let enhancedAccessibilityValue = enhancedAccessibilityValue else {
            return nil
        }
        
        let result = ipcClient.call(
            method: PercentageOfVisibleAreaIpcMethod(),
            arguments: enhancedAccessibilityValue.uniqueIdentifier
        )
        
        // TODO: Replace nil with 0 in PercentageOfVisibleAreaIpcMethodHandler?
        return (result.data ?? .none) ?? 0
    }
    
    public var center: XCUICoordinate {
        return coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
    }
}
