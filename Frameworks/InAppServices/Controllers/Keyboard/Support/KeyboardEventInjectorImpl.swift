import UIKit
import MixboxIpcCommon

public final class KeyboardEventInjectorImpl: KeyboardEventInjector {
    private let application: UIApplication
    
    public init(application: UIApplication) {
        self.application = application
    }
    
    public func inject(events: [KeyboardEvent], completion: @escaping () -> ()) {
        for event in events {
            DispatchQueue.main.async { [application] in
                let event = MBKeyboardEventFactory.event(
                    withTime: MBKeyboardEventFactory.currentTime(),
                    usagePage: event.usagePage,
                    usage: event.usage,
                    down: event.down
                )
                application.handleKeyHIDEvent(event)
            }
        }
        
        DispatchQueue.main.async {
            completion()
        }
    }
}
