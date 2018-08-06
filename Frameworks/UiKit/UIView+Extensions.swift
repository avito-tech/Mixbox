import UIKit

@objc public extension UIView {
    final var mb_size: CGSize  {
        @inline(__always) get { return frame.size }
        @inline(__always) set { frame.size = newValue }
    }
    
    final var mb_origin: CGPoint {
        @inline(__always) get { return frame.origin }
        @inline(__always) set { frame.origin = newValue }
    }
    
    final var mb_width: CGFloat {
        @inline(__always) get { return mb_size.width }
        @inline(__always) set { mb_size.width = newValue }
    }
    
    final var mb_height: CGFloat {
        @inline(__always) get { return mb_size.height }
        @inline(__always) set { mb_size.height = newValue }
    }
    
    final var mb_x: CGFloat {
        @inline(__always) get { return mb_origin.x }
        @inline(__always) set { mb_origin.x = newValue }
    }
    
    final var mb_y: CGFloat {
        @inline(__always) get { return mb_origin.y }
        @inline(__always) set { mb_origin.y = newValue }
    }
    
    final var mb_centerX: CGFloat {
        @inline(__always) get { return center.x }
        @inline(__always) set { mb_x = newValue - mb_width / 2 }
    }
    
    final var mb_centerY: CGFloat {
        @inline(__always) get { return center.y }
        @inline(__always) set { mb_y = newValue - mb_height / 2 }
    }
    
    final var mb_left: CGFloat {
        @inline(__always) get { return mb_x }
        @inline(__always) set { mb_x = newValue }
    }
    
    final var mb_right: CGFloat {
        @inline(__always) get { return mb_left + mb_width }
        @inline(__always) set { mb_left = newValue - mb_width }
    }
    
    final var mb_top: CGFloat {
        @inline(__always) get { return mb_y }
        @inline(__always) set { mb_y = newValue }
    }
    
    final var mb_bottom: CGFloat {
        @inline(__always) get { return mb_top + mb_height }
        @inline(__always) set { mb_top = newValue - mb_height }
    }
}
