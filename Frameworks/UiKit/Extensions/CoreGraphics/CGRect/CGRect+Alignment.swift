#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public extension CGRect {
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
        get { return midX }
        set { mb_left = newValue - width / 2 }
    }
    var mb_centerY: CGFloat {
        get { return midY }
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
}

#endif
