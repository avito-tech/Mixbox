#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public protocol KeyboardEventInjector: AnyObject {
    func inject(events: [KeyboardEvent], completion: @escaping (ErrorString?) -> ())
}

#endif
