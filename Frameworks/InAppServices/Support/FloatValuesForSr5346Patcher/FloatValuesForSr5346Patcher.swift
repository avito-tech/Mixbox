#if MIXBOX_ENABLE_IN_APP_SERVICES
import Foundation
import UIKit

public protocol FloatValuesForSr5346Patcher {
    func patched(float: CGFloat) -> CGFloat
}

extension FloatValuesForSr5346Patcher {
    public func patched(frame: CGRect) -> CGRect {
        return CGRect(
            x: patched(float: frame.origin.x),
            y: patched(float: frame.origin.y),
            width: patched(float: frame.size.width),
            height: patched(float: frame.size.height)
        )
    }
}

#endif
