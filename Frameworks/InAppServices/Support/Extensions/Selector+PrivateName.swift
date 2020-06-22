#if MIXBOX_ENABLE_IN_APP_SERVICES
import Foundation
import UIKit

// TODO: Use everywhere
extension Selector {
    // Suppresses `Use '#selector' instead of explicitly constructing a 'Selector'` warning
    init(privateName: String) {
        self.init(privateName)
    }
}

#endif
