#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public extension CGRect {
    // MARK: - Inversion
    
    func mb_inverted() -> CGRect {
        return CGRect.mb_init(left: mb_right, right: mb_left, top: mb_bottom, bottom: mb_top)
    }
    
    // MARK: - Intersection
    
    func mb_intersectionOrNil(_ other: CGRect) -> CGRect? {
        let cgIntersection = self.intersection(other)
        if cgIntersection == CGRect.null {
            return nil
        } else {
            return cgIntersection
        }
    }
    
    // MARK: - Scaling
    
    func mb_scaleAndTranslate(amount: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x * amount,
            y: origin.y * amount,
            width: size.width * amount,
            height: size.height * amount
        )
    }
    
    // MARK: - Cutting
    
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
