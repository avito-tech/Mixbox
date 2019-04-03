public protocol TextTyper: class {
    var keys: TextTyperKeys { get }
    
    func type(text: String)
}

public protocol TextTyperKeys: class {
    var delete: String { get }
    var `return`: String { get }
    var enter: String { get }
    var tab: String { get }
    var space: String { get }
    var escape: String { get }
    
    var upArrow: String { get }
    var downArrow: String { get }
    var leftArrow: String { get }
    var rightArrow: String { get }
    
    var f1: String { get }
    var f2: String { get }
    var f3: String { get }
    var f4: String { get }
    var f5: String { get }
    var f6: String { get }
    var f7: String { get }
    var f8: String { get }
    var f9: String { get }
    var f10: String { get }
    var f11: String { get }
    var f12: String { get }
    var f13: String { get }
    var f14: String { get }
    var f15: String { get }
    var f16: String { get }
    var f17: String { get }
    var f18: String { get }
    var f19: String { get }
    
    var forwardDelete: String { get }
    var home: String { get }
    var end: String { get }
    var pageUp: String { get }
    var pageDown: String { get }
    var clear: String { get }
    var help: String { get }
    
    var capsLock: String { get }
    var shift: String { get }
    var control: String { get }
    var option: String { get }
    var command: String { get }
    var rightShift: String { get }
    var rightControl: String { get }
    var rightOption: String { get }
    var rightCommand: String { get }
    var secondaryFn: String { get }
}
