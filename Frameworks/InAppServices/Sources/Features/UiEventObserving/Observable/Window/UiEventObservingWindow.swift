#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxIpcCommon
import MixboxFoundation

public final class UiEventObservingWindow: UIWindow, UiEventObservable {
    private let uiEventObservable = UiEventObservableImpl()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIWindow
    
    override public func sendEvent(_ event: UIEvent) {
        let result = uiEventObservable.eventWasSent(event: event, window: self)
        
        if !result.shouldConsumeEvent {
            super.sendEvent(event)
        }
    }
    
    public func add(observer: UiEventObserver) {
        uiEventObservable.add(observer: observer)
    }
    
    public func remove(observer: UiEventObserver) {
        uiEventObservable.remove(observer: observer)
    }
       
    public func contains(observer: UiEventObserver) -> Bool {
        uiEventObservable.contains(observer: observer)
    }
}

#endif
