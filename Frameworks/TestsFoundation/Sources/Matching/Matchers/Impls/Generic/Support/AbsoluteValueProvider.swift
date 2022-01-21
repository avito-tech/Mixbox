import UIKit

public protocol AbsoluteValueProvider {
    func absoluteValue() -> Self
}

extension Double: AbsoluteValueProvider {
    public func absoluteValue() -> Double {
        return abs(self)
    }
}
extension Float: AbsoluteValueProvider {
    public func absoluteValue() -> Float {
        return abs(self)
    }
}
extension CGFloat: AbsoluteValueProvider {
    public func absoluteValue() -> CGFloat {
        return abs(self)
    }
}
