#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public protocol KeyboardEventInjector: class {
    func inject(events: [KeyboardEvent], completion: @escaping (ErrorString?) -> ())
}

#endif
