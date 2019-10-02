#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public extension CGSize {
    // MARK: - Insets
    
    // Shrink size with insets, resulting size will be smaller
    func mb_shrinked(_ insets: UIEdgeInsets) -> CGSize {
        return CGSize(
            width: width - insets.mb_width,
            height: height - insets.mb_height
        )
    }
    
    // Extend size with insets, resulting size will be bigger
    func mb_extended(_ insets: UIEdgeInsets) -> CGSize {
        return mb_shrinked(insets.mb_inverted())
    }
    
    // MARK: - Intersection
    
    // Intersect two sizes (imagine intersection between two rectangles with x = width, y = height)
    // Resulting size will be smaller than self and other or equal
    func mb_intersection(_ other: CGSize) -> CGSize {
        return CGSize(
            width: min(width, other.width),
            height: min(height, other.height)
        )
    }
    
    func mb_intersectionHeight(_ height: CGFloat) -> CGSize {
        return CGSize(
            width: width,
            height: min(self.height, height)
        )
    }
    
    func mb_intersectionWidth(_ width: CGFloat) -> CGSize {
        return CGSize(
            width: min(self.width, width),
            height: height
        )
    }
    
    func mb_intersectionHeight(_ other: CGSize) -> CGSize {
        return mb_intersectionHeight(other.height)
    }
    
    func mb_intersectionWidth(_ other: CGSize) -> CGSize {
        return mb_intersectionWidth(other.width)
    }
    
    // MARK: - Union
    
    // Resulting size will be bigger than self and other or equal
    func mb_union(_ other: CGSize) -> CGSize {
        return CGSize(
            width: max(width, other.width),
            height: max(height, other.height)
        )
    }
    
    func mb_unionWidth(_ width: CGFloat) -> CGSize {
        return CGSize(
            width: max(self.width, width),
            height: height
        )
    }
    
    func mb_unionHeight(_ height: CGFloat) -> CGSize {
        return CGSize(
            width: width,
            height: max(self.height, height)
        )
    }
    
    func mb_unionWidth(_ other: CGSize) -> CGSize {
        return mb_unionWidth(other.width)
    }
    
    func mb_unionHeight(_ other: CGSize) -> CGSize {
        return mb_unionHeight(other.height)
    }
    
    // MARK: - Substraction
    
    // Substract components of CGSize (width and height)
    func mb_minus(_ other: CGSize) -> CGSize {
        return CGSize(width: width - other.width, height: height - other.height)
    }
    
    func mb_minusHeight(_ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: self.height - height)
    }
    
    func mb_minusWidth(_ width: CGFloat) -> CGSize {
        return CGSize(width: self.width - width, height: height)
    }
    
    func mb_minusHeight(_ other: CGSize) -> CGSize {
        return mb_minusHeight(other.height)
    }
    
    func mb_minusWidth(_ other: CGSize) -> CGSize {
        return mb_minusWidth(other.width)
    }
    
    // MARK: - Multiplication
    
    func mb_multiply(_ factor: CGFloat) -> CGSize {
        return CGSize(width: width * factor, height: height * factor)
    }
    
    // MARK: - Addition
    
    // Sum components of CGSize (width and height)
    func mb_plus(_ other: CGSize) -> CGSize {
        return CGSize(
            width: width + other.width,
            height: height + other.height
        )
    }
    
    func mb_plusHeight(_ height: CGFloat) -> CGSize {
        return CGSize(
            width: width,
            height: self.height + height
        )
    }
    
    func mb_plusWidth(_ width: CGFloat) -> CGSize {
        return CGSize(
            width: self.width + width,
            height: height
        )
    }
    
    func mb_plusHeight(_ other: CGSize) -> CGSize {
        return mb_plusHeight(other.height)
    }
    
    func mb_plusWidth(_ other: CGSize) -> CGSize {
        return mb_plusWidth(other.width)
    }
    
    // MARK: - Rounding
    
    func mb_ceil() -> CGSize {
        return CGSize(
            width: CoreGraphics.ceil(width),
            height: CoreGraphics.ceil(height)
        )
    }
    
    func mb_floor() -> CGSize {
        return CGSize(
            width: CoreGraphics.floor(width),
            height: CoreGraphics.floor(height)
        )
    }
    
    func mb_hasZeroArea() -> Bool {
        return width == 0 || height == 0
    }
}

public func +(left: CGSize, right: CGSize) -> CGSize {
    return CGSize(
        width: left.width + right.width,
        height: left.height + right.height
    )
}

public func -(left: CGSize, right: CGSize) -> CGSize {
    return CGSize(
        width: left.width - right.width,
        height: left.height - right.height
    )
}

public func *(left: CGFloat, right: CGSize) -> CGSize {
    return CGSize(
        width: left * right.width,
        height: left * right.height
    )
}

public func *(left: CGSize, right: CGFloat) -> CGSize {
    return right * left
}

public func /(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(
        width: left.width / right,
        height: left.height / right
    )
}

#endif
