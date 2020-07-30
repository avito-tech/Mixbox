#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public extension CGRect {
    func mb_pointToPixel(scale: CGFloat) -> CGRect {
        return mb_scaleAndTranslate(amount: scale)
    }

    func mb_pixelToPoint(scale: CGFloat) -> CGRect {
        return mb_scaleAndTranslate(amount: 1 / scale)
    }
}

#endif
