#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import UIKit

public protocol ViewHierarchyProvider: AnyObject {
    func viewHierarchy() -> ViewHierarchy
}

#endif
