import UIKit

public protocol Divisible {
    func byDividing(_ other: Self) -> Self
}

extension Double: Divisible {
    public func byDividing(_ other: Double) -> Double {
        return self / other
    }
}
extension Float: Divisible {
    public func byDividing(_ other: Float) -> Float {
        return self / other
    }
}
extension CGFloat: Divisible {
    public func byDividing(_ other: CGFloat) -> CGFloat {
        return self / other
    }
}
