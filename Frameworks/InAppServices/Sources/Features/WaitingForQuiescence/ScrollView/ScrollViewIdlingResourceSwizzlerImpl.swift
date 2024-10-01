#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxFoundation

public final class ScrollViewIdlingResourceSwizzlerImpl: ScrollViewIdlingResourceSwizzler {
    public let assertingSwizzler: AssertingSwizzler
    
    public init(assertingSwizzler: AssertingSwizzler) {
        self.assertingSwizzler = assertingSwizzler
    }
    
    public func swizzle() {
        swizzle(
            originalSelector: Selector.mb_init(privateName: "_scrollViewWillBeginDragging"),
            swizzledSelector: #selector(UIScrollView.swizzled_ScrollViewIdlingResourceSwizzler__scrollViewWillBeginDragging)
        )
        swizzle(
            originalSelector: Selector.mb_init(privateName: "_scrollViewDidEndDraggingWithDeceleration:"),
            swizzledSelector: #selector(UIScrollView.swizzled_ScrollViewIdlingResourceSwizzler__scrollViewDidEndDraggingWithDeceleration)
        )
        swizzle(
            originalSelector: Selector.mb_init(privateName: "_stopScrollDecelerationNotify:"),
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
        trackedScrollDeceleration.value?.untrack()
        trackedScrollDeceleration.value = IdlingResourceObjectTracker.instance.track(
            parent: self,
            resourceDescription: {
                TrackedIdlingResourceDescription(
                    name: "scrolling",
                    causeOfResourceBeingTracked: "`-UIScrollView._scrollViewWillBeginDragging()` was called",
                    likelyCauseOfResourceStillBeingTracked: "lifecycle methods weren't called",
                    listOfConditionsThatWillCauseResourceToBeUntracked: [
                        "`-UIScrollView._scrollViewDidEndDraggingWithDeceleration(_:)` is called with argument `false` (deceleration: Bool)",
                        "`-UIScrollView._stopScrollDecelerationNotify(_:)` is called"
                    ]
                )
            }
        )
        
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
