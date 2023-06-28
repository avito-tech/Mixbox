#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

import UIKit

public extension UIEdgeInsets {
    static func mb_init(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) -> UIEdgeInsets {
        return self.init(top: top, left: left, bottom: bottom, right: right)
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
