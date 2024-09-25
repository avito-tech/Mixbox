#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

import UIKit
import MixboxFoundation
#if SWIFT_PACKAGE
import MixboxIoKitObjc
#endif

public final class HandleHidEventSwizzlerImpl: HandleHidEventSwizzler {
    private let assertingSwizzler: AssertingSwizzler
    private let onceToken = ThreadUnsafeOnceToken<UiApplicationHandleIohidEventObservable>()
    
    public init(
        assertingSwizzler: AssertingSwizzler)
    {
        self.assertingSwizzler = assertingSwizzler
    }
    
    public func swizzle() -> UiApplicationHandleIohidEventObservable {
        return onceToken.executeOnce {
            swizzleWhileBeingExecutedOnce()
        }
    }
    
    private func swizzleWhileBeingExecutedOnce() -> UiApplicationHandleIohidEventObservable {
        assertingSwizzler.swizzle(
            class: UIApplication.self,
            originalSelector: Selector(("_handleHIDEvent:")),
            swizzledSelector: #selector(UIApplication.swizzled_HandleHidEventSwizzlerImpl__handleHIDEvent),
            methodType: .instanceMethod,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
        
        return SingletonHandleHidEventObserver.instance
    }
}

extension UIApplication {
    @objc fileprivate func swizzled_HandleHidEventSwizzlerImpl__handleHIDEvent(_ event: IOHIDEventRef) {
        self.swizzled_HandleHidEventSwizzlerImpl__handleHIDEvent(event)
        
        SingletonHandleHidEventObserver.instance.uiApplicationHandledIohidEvent(event)
    }
}

#endif
