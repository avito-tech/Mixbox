#if MIXBOX_ENABLE_IN_APP_SERVICES

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
//        caAnimationIdlingSupport.swizzle()
//        caLayerIdlingSupport.swizzle()
    }
}

#endif
