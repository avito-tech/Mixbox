#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public extension CGRect {
    var mb_area: CGFloat {
        return size.mb_area
    }
    
    func mb_hasZeroArea() -> Bool {
        return size.mb_hasZeroArea()
    }
}

#endif
