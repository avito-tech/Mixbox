import UIKit
import MixboxUiKit

extension UIView {
    // MARK: - Alignment: single axis
    public final func layout(left: CGFloat, right: CGFloat) {
        self.mb_left = left
        self.mb_width = right - left
    }
    
    public final func layout(top: CGFloat, bottom: CGFloat) {
        self.mb_top = top
        self.mb_height = bottom - top
    }
    
    public final func layout(left: CGFloat, top: CGFloat) {
        self.mb_left = left
        self.mb_top = top
    }
    
    // MARK: - Alignment: all axis
    public final func layout(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        layout(left: left, right: right)
        layout(top: top, bottom: bottom)
    }
    
    public final func layout(left: CGFloat, right: CGFloat, top: CGFloat, height: CGFloat) {
        layout(left: left, right: right)
        self.mb_top = top
        self.mb_height = height
    }
    
    public final func layout(left: CGFloat, right: CGFloat, bottom: CGFloat, height: CGFloat) {
        layout(left: left, right: right)
        self.mb_height = height
        self.mb_bottom = bottom
    }
    
    public final func layout(top: CGFloat, bottom: CGFloat, left: CGFloat, width: CGFloat) {
        layout(top: top, bottom: bottom)
        self.mb_left = left
        self.mb_width = width
    }
    
    public final func layout(top: CGFloat, bottom: CGFloat, right: CGFloat, width: CGFloat) {
        layout(top: top, bottom: bottom)
        self.mb_width = width
        self.mb_right = right
    }
    
    public final func layout(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        layout(top: top, bottom: bottom)
        self.mb_left = left
        self.mb_width = right - left
    }
    
    public final func layout(right: CGFloat, bottom: CGFloat) {
        self.mb_right = right
        self.mb_bottom = bottom
    }
    
    public final func layout(left: CGFloat, bottom: CGFloat) {
        self.mb_left = left
        self.mb_bottom = bottom
    }
    
    public final func layout(right: CGFloat, top: CGFloat) {
        self.mb_right = right
        self.mb_top = top
    }
    
    public final func layout(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) {
        self.mb_left = left
        self.mb_top = top
        self.mb_width = width
        self.mb_height = height
    }
    
    public final func layout(right: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) {
        self.mb_left = right - width
        self.mb_top = top
        self.mb_width = width
        self.mb_height = height
    }
    
    public final func layout(left: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) {
        self.mb_left = left
        self.mb_width = width
        self.mb_height = height
        self.mb_centerY = centerY
    }
    
    public final func layout(right: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) {
        self.mb_width = width
        self.mb_right = right
        self.mb_height = height
        self.mb_centerY = centerY
    }
    
    public final func layout(top: CGFloat, mb_centerX: CGFloat, width: CGFloat, height: CGFloat) {
        self.mb_width = width
        self.mb_top = top
        self.mb_height = height
        self.mb_centerX = mb_centerX
    }
    
    // MARK: - Alignment with autoresize: single axis
    
    // Y coordinate is not specified
    public final func layout(left: CGFloat, right: CGFloat, fitHeight: CGFloat) {
        self.mb_left = left
        self.mb_width = right - left
        self.mb_height = min(fitHeight, sizeThatFits(CGSize(width: mb_width, height: fitHeight)).height)
    }
    
    // X coordinate is not specified
    public final func layout(top: CGFloat, bottom: CGFloat, fitWidth: CGFloat) {
        self.mb_top = top
        self.mb_height = bottom - top
        self.mb_width = min(fitWidth, sizeThatFits(CGSize(width: fitWidth, height: mb_height)).width)
    }
    
    // MARK: - Alignment with autoresize: all axis
    
    // Fixed width, flexible height:
    
    public final func layout(left: CGFloat, right: CGFloat, top: CGFloat, fitHeight: CGFloat) {
        layout(left: left, right: right, fitHeight: fitHeight)
        self.mb_top = top
    }
    
    public final func layout(left: CGFloat, right: CGFloat, top: CGFloat, fitBottom: CGFloat) {
        layout(left: left, right: right, top: top, fitHeight: fitBottom - top)
    }
    
    public final func layout(left: CGFloat, right: CGFloat, bottom: CGFloat, fitHeight: CGFloat) {
        layout(left: left, right: right, fitHeight: fitHeight)
        self.mb_bottom = bottom
    }
    
    public final func layout(left: CGFloat, right: CGFloat, bottom: CGFloat, fitTop: CGFloat) {
        layout(left: left, right: right, bottom: bottom, fitHeight: bottom - fitTop)
    }
    
    // Fixed height, flexible width:
    
    public final func layout(top: CGFloat, bottom: CGFloat, left: CGFloat, fitWidth: CGFloat) {
        layout(top: top, bottom: bottom, fitWidth: fitWidth)
        self.mb_left = left
    }
    
    public final func layout(top: CGFloat, bottom: CGFloat, left: CGFloat, fitRight: CGFloat) {
        layout(top: top, bottom: bottom, left: left, fitWidth: fitRight - left)
    }
    
    public final func layout(top: CGFloat, bottom: CGFloat, right: CGFloat, fitWidth: CGFloat) {
        layout(top: top, bottom: bottom, fitWidth: fitWidth)
        self.mb_right = right
    }
    
    public final func layout(top: CGFloat, bottom: CGFloat, right: CGFloat, fitLeft: CGFloat) {
        layout(top: top, bottom: bottom, right: right, fitWidth: right - fitLeft)
    }
    
    public final func layout(left: CGFloat, top: CGFloat, height: CGFloat, fitRight: CGFloat) {
        layout(top: top, bottom: top + height, left: left, fitRight: fitRight)
    }
    
    public final func layout(left: CGFloat, bottom: CGFloat, width: CGFloat, height: CGFloat) {
        self.mb_left = left
        self.mb_height = height
        self.mb_width = width
        self.mb_bottom = bottom
    }
    
    // MARK: - Resize
    
    public final func resizeToFitSize(_ size: CGSize) {
        self.mb_size = sizeThatFits(size).mb_intersection(size)
    }
}
