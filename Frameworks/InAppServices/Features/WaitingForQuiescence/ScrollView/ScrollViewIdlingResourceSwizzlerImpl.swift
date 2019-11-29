#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class ScrollViewIdlingResourceSwizzlerImpl: ScrollViewIdlingResourceSwizzler {
    public let assertingSwizzler: AssertingSwizzler
    
    public init(assertingSwizzler: AssertingSwizzler) {
        self.assertingSwizzler = assertingSwizzler
    }
    
    public func swizzle() {
        swizzle(
            originalSelector: Selector(privateName: "_scrollViewWillBeginDragging"),
            swizzledSelector: #selector(UIScrollView.swizzled_ScrollViewIdlingResourceSwizzler__scrollViewWillBeginDragging)
        )
        swizzle(
            originalSelector: Selector(privateName: "_scrollViewDidEndDraggingWithDeceleration:"),
            swizzledSelector: #selector(UIScrollView.swizzled_ScrollViewIdlingResourceSwizzler__scrollViewDidEndDraggingWithDeceleration)
        )
        swizzle(
            originalSelector: Selector(privateName: "_stopScrollDecelerationNotify:"),
            swizzledSelector: #selector(UIScrollView.swizzled_ScrollViewIdlingResourceSwizzler__stopScrollDecelerationNotify)
        )
    }
    
    private func swizzle(
        originalSelector: Selector,
        swizzledSelector: Selector)
    {
        assertingSwizzler.swizzle(
            class: UIScrollView.self,
            originalSelector: originalSelector,
            swizzledSelector: swizzledSelector,
            methodType: .instanceMethod,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
    }
}

extension UIScrollView {
    @objc fileprivate func swizzled_ScrollViewIdlingResourceSwizzler__scrollViewWillBeginDragging() {
        IdlingResourceObjectTracker.instance.track(object: self, state: .busy)
        
        swizzled_ScrollViewIdlingResourceSwizzler__scrollViewWillBeginDragging()
    }
    
    @objc fileprivate func swizzled_ScrollViewIdlingResourceSwizzler__scrollViewDidEndDraggingWithDeceleration(deceleration: Bool) {
        if !deceleration {
            IdlingResourceObjectTracker.instance.track(object: self, state: .idle)
        }
        
        swizzled_ScrollViewIdlingResourceSwizzler__scrollViewDidEndDraggingWithDeceleration(deceleration: deceleration)
    }
    
    @objc fileprivate func swizzled_ScrollViewIdlingResourceSwizzler__stopScrollDecelerationNotify(notify: Bool) {
        IdlingResourceObjectTracker.instance.track(object: self, state: .idle)
        
        swizzled_ScrollViewIdlingResourceSwizzler__stopScrollDecelerationNotify(notify: notify)
    }
}

#endif
