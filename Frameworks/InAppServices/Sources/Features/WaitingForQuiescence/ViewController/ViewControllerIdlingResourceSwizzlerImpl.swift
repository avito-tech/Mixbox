#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation
import UIKit
import MixboxUiKit

// Rewritten from Objective-C to Swift:
// https://github.com/google/EarlGrey/blob/251b06cd09a8b0b478c295676bb9c385b9a59c10/EarlGrey/Additions/UIViewController%2BGREYAdditions.m#L1
//
public final class ViewControllerIdlingResourceSwizzlerImpl: ViewControllerIdlingResourceSwizzler {
    public let assertingSwizzler: AssertingSwizzler
    
    public init(assertingSwizzler: AssertingSwizzler) {
        self.assertingSwizzler = assertingSwizzler
    }
    
    public func swizzle() {
        swizzle(
            originalSelector: #selector(UIViewController.viewWillAppear(_:)),
            swizzledSelector: #selector(UIViewController.swizzled_ViewControllerSwizzlerImpl_viewWillAppear(_:))
        )
        swizzle(
            originalSelector: #selector(UIViewController.viewDidAppear(_:)),
            swizzledSelector: #selector(UIViewController.swizzled_ViewControllerSwizzlerImpl_viewDidAppear(_:))
        )
        swizzle(
            originalSelector: #selector(UIViewController.viewWillDisappear(_:)),
            swizzledSelector: #selector(UIViewController.swizzled_ViewControllerSwizzlerImpl_viewWillDisappear(_:))
        )
        swizzle(
            originalSelector: #selector(UIViewController.viewDidDisappear(_:)),
            swizzledSelector: #selector(UIViewController.swizzled_ViewControllerSwizzlerImpl_viewDidDisappear(_:))
        )
        swizzle(
            originalSelector: Selector.mb_init(privateName: "viewWillMoveToWindow:"),
            swizzledSelector: #selector(UIViewController.swizzled_ViewControllerSwizzlerImpl_viewWillMoveToWindow(_:))
        )
        swizzle(
            originalSelector: Selector.mb_init(privateName: "viewDidMoveToWindow:shouldAppearOrDisappear:"),
            swizzledSelector: #selector(UIViewController.swizzled_ViewControllerSwizzlerImpl_viewDidMoveToWindow(_:shouldAppearOrDisappear:))
        )
        
        // For tracking rootViewController
        swizzle(
            class: UIWindow.self,
            originalSelector: #selector(setter: UIWindow.rootViewController),
            swizzledSelector: #selector(UIWindow.swizzled_setRootViewController(_:))
        )
        
        swizzle(
            class: UIWindow.self,
            originalSelector: #selector(setter: UIWindow.isHidden),
            swizzledSelector: #selector(UIWindow.swizzled_setHidden(_:))
        )
    }
    
    private func swizzle(
        class: NSObject.Type = UIViewController.self,
        originalSelector: Selector,
        swizzledSelector: Selector)
    {
        assertingSwizzler.swizzle(
            class: `class`,
            originalSelector: originalSelector,
            swizzledSelector: swizzledSelector,
            methodType: .instanceMethod,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
    }
}

extension UIViewController {
    private static var keyboardRelatedViewControllerClasses: [AnyClass] {
        var classes = [AnyClass]()
        
        let classNames = [
            "UIEditingOverlayViewController",
            "UICompatibilityInputViewController"
        ]
        
        classNames.forEach { className in
            if let `class` = NSClassFromString(className) {
                classes.append(`class`)
            }
        }
        
        return classes
    }
    
    private func isKeyboardRelatedViewControllerClass() -> Bool {
        return UIViewController.keyboardRelatedViewControllerClasses.contains { keyboardRelatedViewControllerClass in
            self.isKind(of: keyboardRelatedViewControllerClass)
        }
    }
    
    @objc fileprivate func swizzled_ViewControllerSwizzlerImpl_viewWillAppear(_ animated: Bool) {
        // Do not track this state for some keyboard related classes due to issues seen with untracking.
        
        // For some keyboard have issue with untracking.
        if !isKeyboardRelatedViewControllerClass() {
            trackAppearanceStateWillChange(
                resourceDescription: {
                    TrackedIdlingResourceDescription(
                        name: "view appearing",
                        causeOfResourceBeingTracked: "`-UIViewController.viewWillAppear(_:)` was called",
                        likelyCauseOfResourceStillBeingTracked: "viewDidAppear was not called",
                        listOfConditionsThatWillCauseResourceToBeUntracked: [
                            "`-UIViewController.viewDidAppear(_:)` is called",
                            "`-UIViewController.viewWillAppear(_:)` is called again",
                            "`-UIViewController.viewDidDisappear(_:)` is called",
                            "`-UIViewController.viewDidMoveToWindow(_:shouldAppearOrDisappear:)` is called with first argument `nil` (window: UIWindow)",
                            "if view controller was rootViewController for window and window changed it's rootViewController to another view controller"
                        ]
                    )
                },
                trackedIdlingResource: {
                    $0.trackedViewAppearing
                }
            )
        }
        
        swizzled_ViewControllerSwizzlerImpl_viewWillAppear(animated)
    }
    
    @objc fileprivate func swizzled_ViewControllerSwizzlerImpl_viewDidAppear(_ animated: Bool) {
        trackedViewAppearing.value?.untrack()
        trackedRootViewControllerAppearing.value?.untrack()
        
        didAppear.value = true
        
        swizzled_ViewControllerSwizzlerImpl_viewDidAppear(animated)
    }
    
    @objc fileprivate func swizzled_ViewControllerSwizzlerImpl_viewWillDisappear(_ animated: Bool) {
        trackAppearanceStateWillChange(
            resourceDescription: {
                TrackedIdlingResourceDescription(
                    name: "view disappearing",
                    causeOfResourceBeingTracked: "`-UIViewController.viewWillDisappear(_:)` was called",
                    likelyCauseOfResourceStillBeingTracked: "viewDidDisappear was not called",
                    listOfConditionsThatWillCauseResourceToBeUntracked: [
                        "`-UIViewController.viewDidDisappear(_:)` is called",
                        "`-UIViewController.viewWillDisappear(_:)` is called again",
                        "`-UIViewController.viewDidMoveToWindow(_:shouldAppearOrDisappear:)` is called with first argument `nil` (window: UIWindow)"
                    ]
                )
            },
            trackedIdlingResource: {
                $0.trackedViewDisappearing
            }
        )
        
        swizzled_ViewControllerSwizzlerImpl_viewWillDisappear(animated)
    }
    
    @objc fileprivate func swizzled_ViewControllerSwizzlerImpl_viewDidDisappear(_ animated: Bool) {
        trackedViewAppearing.value?.untrack()
        trackedViewDisappearing.value?.untrack()
        trackedRootViewControllerAppearing.value?.untrack()

        didAppear.value = false
        
        swizzled_ViewControllerSwizzlerImpl_viewDidDisappear(animated)
    }
    
    @objc fileprivate func swizzled_ViewControllerSwizzlerImpl_viewWillMoveToWindow(_ window: UIWindow?) {
        isMovingToNilWindow.value = (window == nil)
        
        swizzled_ViewControllerSwizzlerImpl_viewWillMoveToWindow(window)
    }
    
    @objc fileprivate func swizzled_ViewControllerSwizzlerImpl_viewDidMoveToWindow(_ window: UIWindow?, shouldAppearOrDisappear: Bool) {
        // Untrack the UIViewController when it moves to a nil window. We must clear the state regardless
        // of |arg|, because viewDidAppear, viewWillDisappear or viewDidDisappear will not be called.
        if window == nil {
            trackedViewAppearing.value?.untrack()
            trackedViewDisappearing.value?.untrack()
            trackedRootViewControllerAppearing.value?.untrack()
        }
        
        swizzled_ViewControllerSwizzlerImpl_viewDidMoveToWindow(window, shouldAppearOrDisappear: shouldAppearOrDisappear)
    }
    
    private func trackAppearanceStateWillChange(
        resourceDescription: @escaping () -> TrackedIdlingResourceDescription,
        trackedIdlingResource: @escaping (UIViewController) -> AssociatedObject<TrackedIdlingResource>
    ) {
        guard !isMovingToNilWindow.value else {
            return
        }
        
        // Interactive transitions can cancel and cause imbalance of will and did calls.

        if let coordinator = self.transitionCoordinator, coordinator.initiallyInteractive {
            let contextHandler: (UIViewControllerTransitionCoordinatorContext?) -> () = { [weak self] context in
                guard let strongSelf = self else {
                    return
                }
                
                if let context = context, context.isCancelled {
                    trackedIdlingResource(strongSelf).value?.untrack()
                }
            }
            
            if #available(iOS 10.0, *) {
                coordinator.notifyWhenInteractionChanges(contextHandler)
            } else {
                coordinator.notifyWhenInteractionEnds(contextHandler)
            }
        }
        
        trackedIdlingResource(self).value?.untrack()
        trackedIdlingResource(self).value = IdlingResourceObjectTracker.instance.track(
            parent: self,
            resourceDescription: resourceDescription
        )
    }
    
    fileprivate func trackAsRootViewController(
        window: UIWindow,
        methodDescription: String
    ) {
        if window.isHidden {
            // Untrack state for hidden windows. When window becomes visible, this method will be called again.
            trackedViewAppearing.value?.untrack()
            trackedRootViewControllerAppearing.value?.untrack()
        } else if !didAppear.value {
            trackedRootViewControllerAppearing.value?.untrack()
            trackedRootViewControllerAppearing.value = IdlingResourceObjectTracker.instance.track(
                parent: self,
                resourceDescription: {
                    TrackedIdlingResourceDescription(
                        name: "root view controller appearing",
                        causeOfResourceBeingTracked: "`\(methodDescription)` was called",
                        likelyCauseOfResourceStillBeingTracked: "unknown", // I have no idea
                        listOfConditionsThatWillCauseResourceToBeUntracked: [
                            "`-UIWindow.setRootViewController(_:)` is called and previous root view controller is currently tracked view controller",
                            "`-UIWindow.setHidden(_:)` is called with argument `true` (hidden: Bool) and root view controller is currently tracked view controller",
                            "`-UIViewController.viewDidAppear(_:)` is called",
                            "`-UIViewController.viewDidDisappear(_:)` is called",
                            "`-UIViewController.viewDidMoveToWindow(_:shouldAppearOrDisappear:)` is called with first argument `nil` (window: UIWindow)"
                        ]
                    )
                }
            )
        }
    }
    
    fileprivate func untrackDueToRootViewControllerChangedForWindow() {
        trackedViewAppearing.value?.untrack()
        trackedRootViewControllerAppearing.value?.untrack()
    }
    
    private var isMovingToNilWindow: AssociatedValue<Bool> {
        return AssociatedValue(container: self, key: #function, defaultValue: false)
    }
    
    private var didAppear: AssociatedValue<Bool> {
        return AssociatedValue(container: self, key: #function, defaultValue: false)
    }
    
    private var trackedViewAppearing: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(container: self, key: #function)
    }
    
    private var trackedViewDisappearing: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(container: self, key: #function)
    }
    
    private var trackedRootViewControllerAppearing: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(container: self, key: #function)
    }
}

extension UIWindow {
    @objc fileprivate func swizzled_setRootViewController(_ newValue: UIViewController?) {
        let oldValue = self.rootViewController
        
        // Don't track the same rootviewcontroller more than once.
        let isAlreadyBeingTracked = oldValue == newValue
        if !isAlreadyBeingTracked {
            oldValue?.untrackDueToRootViewControllerChangedForWindow()
            newValue?.trackAsRootViewController(
                window: self,
                methodDescription: "-UIWindow.setRootViewController(_:)"
            )
        }
        
        swizzled_setRootViewController(newValue)
    }
    
    @objc fileprivate func swizzled_setHidden(_ hidden: Bool) {
        swizzled_setHidden(hidden)
        
        // Method should be called after isHidden is set.
        rootViewController?.trackAsRootViewController(
            window: self,
            methodDescription: "-UIWindow.setHidden(_:)"
        )
    }
}

#endif
