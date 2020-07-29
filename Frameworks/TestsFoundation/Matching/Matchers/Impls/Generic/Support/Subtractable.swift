public protocol Subtractable {
    func bySubtracting(_ other: Self) -> Self
}

extension Double: Subtractable {
    public func bySubtracting(_ other: Double) -> Double {
        return self - other
    }
}
extension Float: Subtractable {
    public func bySubtracting(_ other: Float) -> Float {
        return self - other
    }
}
extension CGFloat: Subtractable {
    public func bySubtracting(_ other: CGFloat) -> CGFloat {
        return self - other
    }
}
extension Float80: Subtractable {
    public func bySubtracting(_ other: Float80) -> Float80 {
        return self - other
    }
}
