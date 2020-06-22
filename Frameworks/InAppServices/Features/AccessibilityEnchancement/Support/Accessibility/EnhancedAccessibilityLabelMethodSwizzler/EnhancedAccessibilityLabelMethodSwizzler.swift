#if MIXBOX_ENABLE_IN_APP_SERVICES
import Foundation
import UIKit

public protocol EnhancedAccessibilityLabelMethodSwizzler {
    func swizzleAccessibilityLabelMethod(method: Method)
}

#endif
