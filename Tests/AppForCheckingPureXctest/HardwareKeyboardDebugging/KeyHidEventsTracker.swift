import UIKit

// Usage:
// - Run app in debugger
// - Press "Debug IOHID" button
// - Press some keys
// - Enjoy debugging
final class KeyHidEventsTracker {
    func startTracking() {
        swizzle(
            originalSelector: Selector(("handleKeyHIDEvent:")),
            swizzledSelector: #selector(UIApplication.swizzled_KeyHidEventsTracker_handleKeyHIDEvent)
        )
        
        swizzle(
            originalSelector: Selector(("_enqueueHIDEvent:")),
            swizzledSelector: #selector(UIApplication.swizzled_KeyHidEventsTracker__enqueueHIDEvent)
        )
    }
    
    private func swizzle(
        originalSelector: Selector,
        swizzledSelector: Selector)
    {
        let `class` = UIApplication.self
        
        guard let originalMethod = class_getInstanceMethod(`class`, originalSelector) else {
            preconditionFailure("Failed to swizzle \(originalSelector)")
        }
        guard let swizzledMethod = class_getInstanceMethod(`class`, swizzledSelector) else {
            preconditionFailure("Failed to swizzle \(originalSelector)")
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

private extension UIApplication {
    @objc func swizzled_KeyHidEventsTracker_handleKeyHIDEvent(event: Any) {
        swizzled_KeyHidEventsTracker_handleKeyHIDEvent(event: event)
        
        print(event)
    }
    @objc func swizzled_KeyHidEventsTracker__enqueueHIDEvent(event: Any) {
        swizzled_KeyHidEventsTracker__enqueueHIDEvent(event: event)
        
        print(event)
    }
}
