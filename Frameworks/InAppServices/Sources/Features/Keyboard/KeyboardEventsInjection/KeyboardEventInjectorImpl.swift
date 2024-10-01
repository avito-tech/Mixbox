#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxIpcCommon
import MixboxFoundation
import MixboxIoKit
#if SWIFT_PACKAGE
import MixboxIoKitObjc
#endif
// TODO: DI?
public final class KeyboardEventInjectorImpl: KeyboardEventInjector {
    private let application: UIApplication
    private let iohidEventSender = MBIohidEventSender()
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
        let observer = UiApplicationHandleIohidEventObserver { [iohidEventSender] in
            iohidEventSender.handle($0)
        }
        
        observable.add(
            uiApplicationHandleIohidEventObserver: observer
        )
        
        for event in events {
            DispatchQueue.main.async { [application, iohidEventSender, currentAbsoluteTimeProvider] in
                let event = MixboxIoKit.KeyboardEvent(
                    allocator: kCFAllocatorDefault,
                    timeStamp: currentAbsoluteTimeProvider.currentAbsoluteTime(),
                    usagePage: event.usagePage,
                    usage: event.usage,
                    down: event.down,
                    options: []
                )
                
                iohidEventSender.send(event.iohidEventRef, application: application)
            }
        }
        
        DispatchQueue.main.async { [application, iohidEventSender] in
            iohidEventSender.waitForEventsBeingSent(to: application) { error in
                observable.remove(
                    uiApplicationHandleIohidEventObserver: observer
                )
                completion(error.map { ErrorString($0) })
            }
        }
    }
}

#endif
