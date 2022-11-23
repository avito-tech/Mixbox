#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
import MixboxFoundation

public final class AccessibilityEnhancerImpl: AccessibilityEnhancer {
    private let accessibilityLabelSwizzlerFactory: AccessibilityLabelSwizzlerFactory
    private let fakeCellsSwizzling: FakeCellsSwizzling
    private let shouldEnableFakeCells: Bool
    private let shouldEnhanceAccessibilityValue: Bool
    private let fakeCellManager: FakeCellManager
    private let onceToken = ThreadUnsafeOnceToken<Void>()
    
    public init(
        accessibilityLabelSwizzlerFactory: AccessibilityLabelSwizzlerFactory,
        fakeCellsSwizzling: FakeCellsSwizzling,
        shouldEnableFakeCells: Bool,
        shouldEnhanceAccessibilityValue: Bool,
        fakeCellManager: FakeCellManager)
    {
        self.accessibilityLabelSwizzlerFactory = accessibilityLabelSwizzlerFactory
        self.fakeCellsSwizzling = fakeCellsSwizzling
        self.shouldEnableFakeCells = shouldEnableFakeCells
        self.shouldEnhanceAccessibilityValue = shouldEnhanceAccessibilityValue
        self.fakeCellManager = fakeCellManager
    }
    
    public func enhanceAccessibility() throws {
        _ = try onceToken.executeOnce {
            if shouldEnhanceAccessibilityValue {
                let accessibilityLabelSwizzler = try accessibilityLabelSwizzlerFactory.accessibilityLabelSwizzler()
                accessibilityLabelSwizzler.swizzle()
            }
            
            if shouldEnableFakeCells {
                fakeCellsSwizzling.swizzle()
                FakeCellManagerProvider.fakeCellManager = fakeCellManager
            }
        }
    }
}

#endif
