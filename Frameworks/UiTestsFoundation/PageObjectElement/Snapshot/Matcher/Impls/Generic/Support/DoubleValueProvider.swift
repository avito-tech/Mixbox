import Foundation
import UIKit

public protocol DoubleValueProvider {
    func doubleValue() -> Double
}

extension Double: DoubleValueProvider {
    public func doubleValue() -> Double {
        return self
    }
}
extension Float: DoubleValueProvider {
    public func doubleValue() -> Double {
        return Double(self)
    }
}
extension CGFloat: DoubleValueProvider {
    public func doubleValue() -> Double {
        return Double(self)
    }
}
extension Float80: DoubleValueProvider {
    public func doubleValue() -> Double {
        return Double(self)
    }
}
