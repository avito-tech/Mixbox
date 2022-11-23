#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

import UIKit

extension CGVector {
    public static func mb_init(start: CGPoint, end: CGPoint) -> CGVector {
        return self.init(
            dx: end.x - start.x,
            dy: end.y - start.y
        )
    }
    
    public func mb_length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    // An angle between X and Y, counterclockwise.
    //
    //    y
    //
    //    ^      /
    //    |     /
    //    |    /
    //    |   /.       this angle
    //    |  /  '.
    //    | /     \
    //    |/       ;
    // ---+---------------> x
    //    |
    //    |
    //
    // CGVector(dx: 1, dy: 1).mb_angle() == .pi / 4
    //
    public func mb_angle() -> CGFloat {
        return atan2(dy, dx)
    }
    
    public func mb_scaled(scale: CGFloat) -> CGVector {
        return CGVector(
            dx: dx * scale,
            dy: dy * scale
        )
    }
    
    public func mb_normalized() -> CGVector? {
        let length = mb_length()
        
        guard length != 0 else {
            return nil
        }
        
        return mb_scaled(scale: 1.0 / length)
    }
}

#endif
