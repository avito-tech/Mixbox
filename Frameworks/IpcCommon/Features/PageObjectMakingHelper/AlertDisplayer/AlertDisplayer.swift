#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public protocol AlertDisplayer {
    func display(
        alert: Alert,
        completion: (Result<Void, ErrorString>) -> ())
}

#endif
