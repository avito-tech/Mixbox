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
        trackedScrollDeceleration.value = IdlingResourceObjectTracker.instance.track(parent: self)
        
        swizzled_ScrollViewIdlingResourceSwizzler__scrollViewWillBeginDragging()
    }
    
    @objc fileprivate func swizzled_ScrollViewIdlingResourceSwizzler__scrollViewDidEndDraggingWithDeceleration(deceleration: Bool) {
        if !deceleration {
            trackedScrollDeceleration.value?.untrack()
        }
        
        swizzled_ScrollViewIdlingResourceSwizzler__scrollViewDidEndDraggingWithDeceleration(deceleration: deceleration)
    }
    
    @objc fileprivate func swizzled_ScrollViewIdlingResourceSwizzler__stopScrollDecelerationNotify(notify: Bool) {
        trackedScrollDeceleration.value?.untrack()
        
        swizzled_ScrollViewIdlingResourceSwizzler__stopScrollDecelerationNotify(notify: notify)
    }
    
    fileprivate var trackedScrollDeceleration: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(
            container: self,
            key: "UIScrollView_scrollDeceleration_51CA64E0FD13"
        )
    }
}

#endif
