#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxIpcCommon
import MixboxFoundation

public final class KeyboardEventInjectorImpl: KeyboardEventInjector {
    private let application: UIApplication
    private let factory = MBKeyboardEventFactory()
    private let sender = MBKeyboardEventSender()
    private let handleHidEventSwizzler: HandleHidEventSwizzler
    
    public init(
        application: UIApplication,
        handleHidEventSwizzler: HandleHidEventSwizzler)
    {
        self.application = application
        self.handleHidEventSwizzler = handleHidEventSwizzler
    }
    
    public func inject(events: [KeyboardEvent], completion: @escaping (ErrorString?) -> ()) {
        let observable = handleHidEventSwizzler.swizzle()
        let observer = UiApplicationHandleIohidEventObserver { [sender] in
            sender.handle($0)
        }
        
        observable.add(
            uiApplicationHandleIohidEventObserver: observer
        )
        
        for event in events {
            DispatchQueue.main.async { [application, factory, sender] in
                let eventOrNil = factory.event(
                    withTime: factory.currentTime(),
                    usagePage: event.usagePage,
                    usage: event.usage,
                    down: event.down
                )
                
                if let event = eventOrNil {
                    sender.send(event, application: application)
                }
            }
        }
        
        DispatchQueue.main.async { [application, sender] in
            sender.waitForEventsBeingSent(to: application) { error in
                observable.remove(
                    uiApplicationHandleIohidEventObserver: observer
                )
                completion(error.map { ErrorString($0) })
            }
        }
    }
}

#endif
