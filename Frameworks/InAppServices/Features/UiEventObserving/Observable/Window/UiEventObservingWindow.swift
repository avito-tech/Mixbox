#if MIXBOX_ENABLE_IN_APP_SERVICES

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
        uiEventObservable.eventWasSent(event: event, window: self)
        
        super.sendEvent(event)
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
