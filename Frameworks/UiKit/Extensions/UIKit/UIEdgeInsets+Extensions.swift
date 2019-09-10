#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public extension UIEdgeInsets {
    static func mb_init(top: CGFloat) -> UIEdgeInsets {
        return self.init(top: top, left: 0, bottom: 0, right: 0)
    }
    
    static func mb_init(top: CGFloat, bottom: CGFloat) -> UIEdgeInsets {
        return self.init(top: top, left: 0, bottom: bottom, right: 0)
    }
    
    func mb_inverted() -> UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
    
    func mb_merged(with insets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: max(top, insets.top),
            left: max(left, insets.left),
            bottom: max(bottom, insets.bottom),
            right: max(right, insets.right)
        )
    }
    
    var mb_width: CGFloat {
        return left + right
    }
    
    var mb_height: CGFloat {
        return top + bottom
    }
    
    var mb_size: CGSize {
        return CGSize(width: mb_width, height: mb_height)
    }
}

public func +(left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    var insets = left
    insets.top += right.top
    insets.bottom += right.bottom
    insets.left += right.left
    insets.right += right.right
    return insets
}

public func -(left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    var insets = left
    insets.top -= right.top
    insets.bottom -= right.bottom
    insets.left -= right.left
    insets.right -= right.right
    return insets
}

#endif
