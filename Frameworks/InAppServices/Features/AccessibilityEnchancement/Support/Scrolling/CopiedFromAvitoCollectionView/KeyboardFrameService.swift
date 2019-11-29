#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

// Copypasted from other app. TODO: Share?

private struct KeyboardFrameObserver {
    weak var object: AnyObject?
    
    var onKeyboardFrameWillChange: ((_ change: KeyboardFrameChange) -> ())?
    var onKeyboardFrameDidChange: ((_ endFrame: CGRect) -> ())?
    var onKeyboardWillShow: ((_ change: KeyboardFrameChange) -> ())?
    var onKeyboardWillHide: ((_ endFrame: CGRect) -> ())?
}

// MARK: -
private class KeyboardFrameObservers {
    private var observers = [KeyboardFrameObserver]()
    
    func allObservers() -> [KeyboardFrameObserver] {
        observers = observers.filter { $0.object != nil }
        return observers
    }
    
    func append(_ observer: KeyboardFrameObserver) {
        if let index = allObservers().firstIndex(where: { $0.object === observer.object }) {
            // do not store one observer twice
            observers.remove(at: index)
        }
        observers.append(observer)
    }
}

// MARK: -
public final class KeyboardFrameService: KeyboardFrameProvider {
    private let keyboardFrameObservers = KeyboardFrameObservers()
    
    // Note: Keyboard frames are relative to screen (can be converted from view nil)
    
    // Keyboard frame before and after any animation, or begin frame inside animation
    public private(set) var keyboardFrameInWindow: CGRect
    
    // Keyboard frame before and after any animation, or end frame inside animation
    public private(set) var nextKeyboardFrameInWindow: CGRect
    
    // MARK: - Init
    public init() {
        let initialFrame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.size.height,
            width: UIScreen.main.bounds.size.width,
            height: 0
        )
        
        keyboardFrameInWindow = initialFrame
        nextKeyboardFrameInWindow = initialFrame
        
        startObserving()
    }
    
    deinit {
        stopObserving()
    }
    
    // MARK: - Private
    private func startObserving() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardDidChangeFrame(_:)),
            name: UIResponder.keyboardDidChangeFrameNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func stopObserving() {
        // TODO: I did not get this swiftlint rule:
        // swiftlint:disable:next notification_center_detachment
        NotificationCenter.default.removeObserver(self)
    }
    
    private func keyboardFrameChangeForNotification(_ notification: Notification)
        -> KeyboardFrameChange?
    {
        if let info = (notification as NSNotification).userInfo,
            let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let keyboardFrameBegin = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardFrameEnd = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let viewAnimationCurveValue = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let viewAnimationCurve = UIView.AnimationCurve(rawValue: viewAnimationCurveValue)
        {
            return KeyboardFrameChange(
                animationDuration: animationDuration,
                keyboardFrameBegin: keyboardFrameBegin,
                keyboardFrameEnd: keyboardFrameEnd,
                viewAnimationCurve: viewAnimationCurve
            )
        }
        
        return nil
    }
    
    // MARK: - Notifications
    @objc private func onKeyboardWillChangeFrame(_ notification: Notification) {
        if let change = keyboardFrameChangeForNotification(notification) {
            keyboardFrameInWindow = change.keyboardFrameBegin
            nextKeyboardFrameInWindow = change.keyboardFrameEnd
            
            for observer in keyboardFrameObservers.allObservers() {
                observer.onKeyboardFrameWillChange?(change)
            }
        }
    }
    
    @objc private func onKeyboardDidChangeFrame(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo,
            let keyboardFrameEnd = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            keyboardFrameInWindow = keyboardFrameEnd
            nextKeyboardFrameInWindow = keyboardFrameEnd
            
            for observer in keyboardFrameObservers.allObservers() {
                observer.onKeyboardFrameDidChange?(keyboardFrameEnd)
            }
        }
    }
    
    @objc private func onKeyboardWillShow(_ notification: Notification) {
        if let change = keyboardFrameChangeForNotification(notification) {
            keyboardFrameInWindow = change.keyboardFrameBegin
            nextKeyboardFrameInWindow = change.keyboardFrameEnd
            
            for observer in keyboardFrameObservers.allObservers() {
                observer.onKeyboardWillShow?(change)
            }
        }
    }
    
    @objc private func onKeyboardWillHide(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo,
            let keyboardFrameEnd = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            keyboardFrameInWindow = keyboardFrameEnd
            nextKeyboardFrameInWindow = keyboardFrameEnd
            
            for observer in keyboardFrameObservers.allObservers() {
                observer.onKeyboardWillHide?(keyboardFrameEnd)
            }
        }
    }
    
    // MARK: - KeyboardFrameProvider
    
    public func addObserver(
        object: AnyObject,
        onKeyboardFrameWillChange: ((_ change: KeyboardFrameChange) -> ())?,
        onKeyboardFrameDidChange: ((_ endFrame: CGRect) -> ())?,
        onKeyboardWillShow: ((_ change: KeyboardFrameChange) -> ())?,
        onKeyboardWillHide: ((_ endFrame: CGRect) -> ())?)
    {
        let observer = KeyboardFrameObserver(
            object: object,
            onKeyboardFrameWillChange: onKeyboardFrameWillChange,
            onKeyboardFrameDidChange: onKeyboardFrameDidChange,
            onKeyboardWillShow: onKeyboardWillShow,
            onKeyboardWillHide: onKeyboardWillHide
        )
        
        keyboardFrameObservers.append(observer)
    }
    
    public func keyboardFrameInView(_ view: UIView) -> CGRect {
        return view.convert(keyboardFrameInWindow, from: nil)
    }
    
    public func nextKeyboardFrameInView(_ view: UIView) -> CGRect {
        return view.convert(nextKeyboardFrameInWindow, from: nil)
    }
}

#endif
