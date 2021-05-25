import Foundation

public final class TargetAction: NSObject {
    public let closure: () -> ()
    
    public init(closure: @escaping () -> ()) {
        self.closure = closure
    }
    
    public var target: AnyObject? {
        return self
    }
    
    public var action: Selector {
        return #selector(TargetAction.targetActionSelector)
    }
    
    @objc private func targetActionSelector() {
        closure()
    }
}
