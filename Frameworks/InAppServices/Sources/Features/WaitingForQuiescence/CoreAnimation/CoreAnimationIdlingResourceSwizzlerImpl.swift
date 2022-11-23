#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation
import UIKit
import MixboxUiKit

public final class CoreAnimationIdlingResourceSwizzlerImpl: CoreAnimationIdlingResourceSwizzler {
    private let caAnimationIdlingSupport: CAAnimationIdlingSupport
    private let caLayerIdlingSupport: CALayerIdlingSupport
    
    public init(
        assertingSwizzler: AssertingSwizzler,
        assertionFailureRecorder: AssertionFailureRecorder)
    {
        self.caAnimationIdlingSupport = CAAnimationIdlingSupport(
            assertingSwizzler: assertingSwizzler,
            assertionFailureRecorder: assertionFailureRecorder
        )
        self.caLayerIdlingSupport = CALayerIdlingSupport(
            assertingSwizzler: assertingSwizzler
        )
    }
    
    public func swizzle() {
        caAnimationIdlingSupport.swizzle()
        caLayerIdlingSupport.swizzle()
    }
}

#endif
