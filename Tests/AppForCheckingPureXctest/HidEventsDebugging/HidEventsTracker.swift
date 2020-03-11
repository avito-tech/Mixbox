import UIKit

// Usage:
// - Run app in debugger
// - Press "Debug IOHID" button
// - Press some keys
// - Enjoy debugging
final class HidEventsTracker {
    func startTracking() {
        swizzle(
            originalSelector: Selector(("handleKeyHIDEvent:")),
            swizzledSelector: #selector(UIApplication.swizzled_HidEventsTracker_handleKeyHIDEvent)
        )
        
        swizzle(
            originalSelector: Selector(("_enqueueHIDEvent:")),
            swizzledSelector: #selector(UIApplication.swizzled_HidEventsTracker__enqueueHIDEvent)
        )
        
        swizzle(
            originalSelector: Selector(("_handleUnicodeEvent:")),
            swizzledSelector: #selector(UIApplication.swizzled_HidEventsTracker__handleUnicodeEvent)
        )
        
        swizzle(
            originalSelector: Selector(("_headsetButtonDown:")),
            swizzledSelector: #selector(UIApplication.swizzled_HidEventsTracker__headsetButtonDown)
        )
        
        swizzle(
            originalSelector: Selector(("_headsetButtonUp:")),
            swizzledSelector: #selector(UIApplication.swizzled_HidEventsTracker__headsetButtonUp)
        )
        
        swizzle(
            originalSelector: Selector(("_handleHIDEvent:")),
            swizzledSelector: #selector(UIApplication.swizzled_HidEventsTracker__handleHIDEvent)
        )
        
        swizzle(
            originalSelector: #selector(UIApplication.sendEvent(_:)),
            swizzledSelector: #selector(UIApplication.swizzled_HidEventsTracker_sendEvent)
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
    
    @objc func swizzled_HidEventsTracker_sendEvent(_ event: UIEvent) {
        swizzled_HidEventsTracker_sendEvent(event)
        
        if let hidEvent = event._hidEvent() {
            print("sendEvent:")
            print(NSString(format: "%@", hidEvent))
        }
    }
    @objc func swizzled_HidEventsTracker_handleKeyHIDEvent(event: Any) {
        swizzled_HidEventsTracker_handleKeyHIDEvent(event: event)
        
        print("handleKeyHIDEvent:")
        print(event)
    }
    @objc func swizzled_HidEventsTracker__enqueueHIDEvent(event: Any) {
        swizzled_HidEventsTracker__enqueueHIDEvent(event: event)
        
        print("_enqueueHIDEvent:")
        print(event)
    }
    @objc func swizzled_HidEventsTracker__handleUnicodeEvent(event: Any) {
        swizzled_HidEventsTracker__handleUnicodeEvent(event: event)
        
        print("_handleUnicodeEvent:")
        print(event)
    }
    @objc func swizzled_HidEventsTracker__headsetButtonDown(event: Any) {
        swizzled_HidEventsTracker__headsetButtonDown(event: event)
        
        print("_headsetButtonDown:")
        print(event)
    }
    @objc func swizzled_HidEventsTracker__headsetButtonUp(event: Any) {
        swizzled_HidEventsTracker__headsetButtonUp(event: event)
        
        print("_headsetButtonUp:")
        print(event)
    }
    @objc func swizzled_HidEventsTracker__handleHIDEvent(event: Any) {
        swizzled_HidEventsTracker__handleHIDEvent(event: event)
        
        print("_handleHIDEvent:")
        print(event)
    }
}
