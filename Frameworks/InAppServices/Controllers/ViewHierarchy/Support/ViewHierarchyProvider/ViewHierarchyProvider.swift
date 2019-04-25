#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import UIKit

public protocol ViewHierarchyProvider {
    func viewHierarchy() -> ViewHierarchy
}

#endif
