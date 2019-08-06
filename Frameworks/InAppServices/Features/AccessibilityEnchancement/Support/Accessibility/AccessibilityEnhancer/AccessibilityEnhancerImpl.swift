#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxTestability
import MixboxFoundation

public final class AccessibilityEnhancerImpl: AccessibilityEnhancer {
    private let accessibilityValueSwizzler: AccessibilityValueSwizzler
    private let fakeCellsSwizzling: FakeCellsSwizzling
    private let shouldEnableFakeCells: Bool
    private let shouldEnhanceAccessibilityValue: Bool
    private let fakeCellManager: FakeCellManager
    private let onceToken = ThreadUnsafeOnceToken()
    
    public init(
        accessibilityValueSwizzler: AccessibilityValueSwizzler,
        fakeCellsSwizzling: FakeCellsSwizzling,
        shouldEnableFakeCells: Bool,
        shouldEnhanceAccessibilityValue: Bool,
        fakeCellManager: FakeCellManager)
    {
        self.accessibilityValueSwizzler = accessibilityValueSwizzler
        self.fakeCellsSwizzling = fakeCellsSwizzling
        self.shouldEnableFakeCells = shouldEnableFakeCells
        self.shouldEnhanceAccessibilityValue = shouldEnhanceAccessibilityValue
        self.fakeCellManager = fakeCellManager
    }
    
    public func enhanceAccessibility() {
        onceToken.executeOnce {
            if shouldEnhanceAccessibilityValue {
                accessibilityValueSwizzler.swizzle()
            }
            
            if shouldEnableFakeCells {
                fakeCellsSwizzling.swizzle()
                FakeCellManagerProvider.fakeCellManager = fakeCellManager
            }
        }
    }
}

#endif
