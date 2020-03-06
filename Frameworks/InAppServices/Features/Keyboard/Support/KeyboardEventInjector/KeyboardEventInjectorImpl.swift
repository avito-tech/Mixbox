#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxIpcCommon
import MixboxIoKit
import MixboxFoundation

// TODO: DI?
public final class KeyboardEventInjectorImpl: KeyboardEventInjector {
    private let application: UIApplication
    private let sender = MBIohidEventSender()
    private let handleHidEventSwizzler: HandleHidEventSwizzler
    private let currentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider = MachCurrentAbsoluteTimeProvider()
    
    public init(
        application: UIApplication,
        handleHidEventSwizzler: HandleHidEventSwizzler)
    {
        self.application = application
        self.handleHidEventSwizzler = handleHidEventSwizzler
    }
    
    public func inject(events: [MixboxIpcCommon.KeyboardEvent], completion: @escaping (ErrorString?) -> ()) {
        let observable = handleHidEventSwizzler.swizzle()
        let observer = UiApplicationHandleIohidEventObserver { [sender] in
            sender.handle($0)
        }
        
        observable.add(
            uiApplicationHandleIohidEventObserver: observer
        )
        
        for event in events {
            DispatchQueue.main.async { [application, sender, currentAbsoluteTimeProvider] in
                let event = MixboxIoKit.KeyboardEvent(
                    allocator: kCFAllocatorDefault,
                    timeStamp: currentAbsoluteTimeProvider.currentAbsoluteTime(),
                    usagePage: event.usagePage,
                    usage: event.usage,
                    down: event.down,
                    optionBits: []
                )
                
                sender.send(event.iohidEventRef, application: application)
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
