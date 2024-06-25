#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

import UIKit

// For offsetting

public func +(left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(
        x: left.x + right.dx,
        y: left.y + right.dy
    )
}

public func +=(left: inout CGPoint, right: CGVector) {

    left = left + right
}

@_transparent
public func +(left: CGVector, right: CGPoint) -> CGPoint {
    return right + left
}

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(
        x: left.x + right.x,
        y: left.y + right.y
    )
}

public func +=(left: inout CGPoint, right: CGPoint) {

    left = left + right
}

public func -(left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(
        x: left.x - right.dx,
        y: left.y - right.dy
    )
}

public func -=(left: inout CGPoint, right: CGVector) {

    left = left - right
}

// For calculating offset

public func -(left: CGPoint, right: CGPoint) -> CGVector {
    return CGVector(
        dx: left.x - right.x,
        dy: left.y - right.y
    )
}

// Inverting
public prefix func -(vector: CGVector) -> CGVector {
    return CGVector(
        dx: -vector.dx,
        dy: -vector.dy
    )
}

// MARK: - Scaling

// E.g.: (100pt, 100pt) * (2,2) = (200pt,200pt)

public func *(left: CGSize, right: CGVector) -> CGSize {
    return CGSize(
        width: left.width * right.dx,
        height: left.height * right.dy
    )
}

public func *=(left: inout CGSize, right: CGVector) {

    left = left * right
}

@_transparent
public func *(left: CGVector, right: CGSize) -> CGSize {
    return right * left
}

public func *(left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(
        x: left.x * right.dx,
        y: left.y * right.dy
    )
}

public func *=(left: inout CGPoint, right: CGVector) {

    left = left * right
}

@_transparent
public func *(left: CGVector, right: CGPoint) -> CGPoint {
    return right * left
}

public func *(left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(
        dx: left.dx * right,
        dy: left.dy * right
    )
}

public func *=(left: inout CGVector, right: CGFloat) {

    left = left * right
}

@_transparent
public func *(left: CGFloat, right: CGVector) -> CGVector {
    return right * left
}

public func /(left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(
        dx: left.dx / right,
        dy: left.dy / right
    )
}

public func /=(left: inout CGVector, right: CGFloat) {

    left = left / right
}

public func /(left: CGSize, right: CGVector) -> CGSize {
    return CGSize(
        width: left.width / right.dx,
        height: left.height / right.dy
    )
}

public func /=(left: inout CGSize, right: CGFloat) {

    left = left / right
}

// E.g.: Ratio
// (100pt, 100pt) / (100pt, 100pt) = (1, 1)
public func /(left: CGVector, right: CGSize) -> CGVector {
    return CGVector(
        dx: left.dx / right.width,
        dy: left.dy / right.height
    )
}

public func /=(left: inout CGVector, right: CGSize) {
    left = left / right
}

public func *(left: CGRect, right: CGFloat) -> CGRect {
    return CGRect(
        origin: left.origin * right,
        size: left.size * right
    )
}

public func *=(left: inout CGRect, right: CGFloat) {    
    left = left * right
}

@_transparent
public func *(left: CGFloat, right: CGRect) -> CGRect {
    return right * left
}

public func *(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(
        x: left.x * right,
        y: left.y * right
    )
}

public func *=(left: inout CGPoint, right: CGFloat) {
    left = left * right
}

@_transparent
public func *(left: CGFloat, right: CGPoint) -> CGPoint {
    return right * left
}

#endif
