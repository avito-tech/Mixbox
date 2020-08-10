#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public protocol UiEventObserver: AnyObject {
    func eventWasSent(event: UIEvent, window: UIWindow)
}

#endif
