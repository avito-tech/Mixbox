#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import UIKit
import MixboxUiKit
import Foundation
import UIKit

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
            originalSelector: Selector(privateName: "viewWillMoveToWindow:"),
            swizzledSelector: #selector(UIViewController.swizzled_ViewControllerSwizzlerImpl_viewWillMoveToWindow(_:))
        )
        swizzle(
            originalSelector: Selector(privateName: "viewDidMoveToWindow:shouldAppearOrDisappear:"),
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
    private static let keyboardRelatedViewControllerClasses: [AnyClass] = {
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
    }()
    
    private func isKeyboardRelatedViewControllerClass() -> Bool {
        return UIViewController.keyboardRelatedViewControllerClasses.contains { keyboardRelatedViewControllerClass in
            self.isKind(of: keyboardRelatedViewControllerClass)
        }
    }
    
    @objc fileprivate func swizzled_ViewControllerSwizzlerImpl_viewWillAppear(_ animated: Bool) {
        // Do not track this state for some keyboard related classes due to issues seen with untracking.
        
        // For some keyboard have issue with untracking.
        if !isKeyboardRelatedViewControllerClass() {
            trackAppearanceStateWillChange { $0.trackedViewAppearing }
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
        trackAppearanceStateWillChange { $0.trackedViewDisappearing }
        
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
        trackedIdlingResource: @escaping (UIViewController) -> AssociatedObject<TrackedIdlingResource>)
    {
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
        
        trackedIdlingResource(self).value = IdlingResourceObjectTracker.instance.track(parent: self)
    }
    
    fileprivate func trackAsRootViewController(window: UIWindow?) {
        // Untrack state for hidden (or nil) windows. When window becomes visible, this method will be
        // called again.
        if window == nil || window?.isHidden == true {
            trackedViewAppearing.value?.untrack()
            trackedRootViewControllerAppearing.value?.untrack()
        } else if !didAppear.value {
            trackedRootViewControllerAppearing.value = IdlingResourceObjectTracker.instance.track(parent: self)
        }
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
            oldValue?.trackAsRootViewController(window: nil)
            newValue?.trackAsRootViewController(window: self)
        }
        
        swizzled_setRootViewController(newValue)
    }
    
    @objc fileprivate func swizzled_setHidden(_ hidden: Bool) {
        swizzled_setHidden(hidden)
        
        // Method should be called after isHidden is set.
        rootViewController?.trackAsRootViewController(window: self)
    }
}

#endif
