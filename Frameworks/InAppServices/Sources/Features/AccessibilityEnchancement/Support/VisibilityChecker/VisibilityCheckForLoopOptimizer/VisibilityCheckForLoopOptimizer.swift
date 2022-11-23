#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxUiKit

// This entity was designed to improve performance of visibility check.
// Before this we could check millions of pixels, now we check thousands.
//
// Example, before optimization we checked grid of pixels that was equal to all pixels,
// after we check smalled grid of pixels. The idea is that if we use uniformly distributed grid
// the visibility check will not lose quality, but it will be performed faster.
//
//       +-------+        +-------+
//       |.......|        | . . . |
//       |.......|        |       |
//       |.......|   =>   | . . . |
//       |.......|        |       |
//       |.......|        | . . . |
//       +-------+        +-------+
//
// The logic is reused in these places:
// - making shifted image
// - comparing images for visibility check
//
// This is because all computated coordinates should be in perfect sync, otherwise visibility check
// wouldn't work correctly. Beware of that if you will modify this entity.
//
public protocol VisibilityCheckForLoopOptimizer {
    func forEachPoint(
        imageSize: IntSize,
        loop: (_ x: Int, _ y: Int) -> ())
}

#endif
