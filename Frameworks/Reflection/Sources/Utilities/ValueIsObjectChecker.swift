// Note that `as? AnyObject` always succeeds (SE-0116) and returns
// bridged type, so it can't be used as an indicator that value is reference type.
public final class ValueIsObjectChecker {
    private class Dummy {}
    
    // This somehow removes warning "'is' test is always true"
    // Bug: https://bugs.swift.org/browse/SR-7394
    private class WarningRemover<T> {
        private let value: Any
        
        init(value: Any) {
            self.value = value
        }
        
        func typeIsAnyClass() -> Bool {
            return type(of: value) is AnyClass
        }
    }
    
    private init() {
    }
    
    public static func isObject(_ value: Any) -> Bool {
        return WarningRemover<Dummy>(value: value).typeIsAnyClass()
    }
}
