#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public extension CGRect {
    // Basic alignment:
    
    var mb_center: CGPoint {
        get {
            return CGPoint(x: mb_centerX, y: mb_centerY)
        }
        set {
            mb_centerX = newValue.x
            mb_centerY = newValue.y
        }
    }
    
    var mb_centerX: CGFloat {
        get { return mb_left + width / 2 }
        set { mb_left = newValue - width / 2 }
    }
    var mb_centerY: CGFloat {
        get { return mb_top + height / 2 }
        set { mb_top = newValue - height / 2 }
    }
    var mb_left: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    var mb_right: CGFloat {
        get { return mb_left + width }
        set { mb_left = newValue - width }
    }
    var mb_top: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    var mb_bottom: CGFloat {
        get { return mb_top + height }
        set { mb_top = newValue - height }
    }
    
    static func mb_init(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) -> CGRect {
        return self.init(x: left, y: top, width: right - left, height: bottom - top)
    }
    
    static func mb_init(left: CGFloat, right: CGFloat, top: CGFloat, height: CGFloat) -> CGRect {
        return self.init(x: left, y: top, width: right - left, height: height)
    }
    
    static func mb_init(left: CGFloat, right: CGFloat, bottom: CGFloat, height: CGFloat) -> CGRect {
        return self.init(x: left, y: bottom - height, width: right - left, height: height)
    }
    
    static func mb_init(left: CGFloat, right: CGFloat, centerY: CGFloat, height: CGFloat) -> CGRect {
        return self.init(x: left, y: centerY - height / 2, width: right - left, height: height)
    }
    
    static func mb_init(right: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return self.init(x: right - width, y: centerY - height / 2, width: width, height: height)
    }
    
    static func mb_init(bottom: CGFloat, centerX: CGFloat, size: CGSize) -> CGRect {
        return self.init(x: centerX - size.width / 2, y: bottom - size.height, width: size.width, height: size.height)
    }
    
    // MARK: - Insets
    
    func mb_shrinked(_ insets: UIEdgeInsets) -> CGRect {
        return inset(by: insets)
    }
    func mb_shrinked(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        return mb_shrinked(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    func mb_extended(_ insets: UIEdgeInsets) -> CGRect {
        return mb_shrinked(insets.mb_inverted())
    }
    func mb_extended(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect {
        return mb_shrinked(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right).mb_inverted())
    }
    
    // MARK: -
    
    func mb_hasZeroArea() -> Bool {
        return size.mb_hasZeroArea()
    }
    
    func mb_inverted() -> CGRect {
        return CGRect.mb_init(left: mb_right, right: mb_left, top: mb_bottom, bottom: mb_top)
    }
    
    func mb_intersectionOrNil(_ other: CGRect) -> CGRect? {
        let cgIntersection = self.intersection(other)
        if cgIntersection == CGRect.null {
            return nil
        } else {
            return cgIntersection
        }
    }
    
    // Return insets needed to shrink self to other.
    // A.mb_shrinked(A.mb_insetsToShrinkToRect(B)) == B
    func mb_insetsToShrinkToRect(_ other: CGRect) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: other.mb_top - mb_top,
            left: other.mb_left - mb_left,
            bottom: mb_bottom - other.mb_bottom,
            right: mb_right - other.mb_right
        )
    }
    
    // Gets intersection with other rect, and cuts it off
    func mb_cutTop(_ other: CGRect) -> CGRect {
        if let intersection = self.mb_intersectionOrNil(other) {
            return CGRect.mb_init(left: mb_left, right: mb_right, top: intersection.mb_bottom, bottom: mb_bottom)
        } else {
            return self // nothing to cut
        }
    }
    
    func mb_cutBottom(_ other: CGRect) -> CGRect {
        if let intersection = self.mb_intersectionOrNil(other) {
            return CGRect.mb_init(left: mb_left, right: mb_right, top: mb_top, bottom: intersection.mb_top)
        } else {
            return self // nothing to cut
        }
    }
    
    func mb_cutLeft(_ other: CGRect) -> CGRect {
        if let intersection = self.mb_intersectionOrNil(other) {
            return CGRect.mb_init(left: intersection.mb_right, right: mb_right, top: mb_top, bottom: mb_bottom)
        } else {
            return self // nothing to cut
        }
    }
    
    func mb_cutRight(_ other: CGRect) -> CGRect {
        if let intersection = self.mb_intersectionOrNil(other) {
            return CGRect.mb_init(left: mb_left, right: intersection.mb_left, top: mb_top, bottom: mb_bottom)
        } else {
            return self // nothing to cut
        }
    }
}

#endif
