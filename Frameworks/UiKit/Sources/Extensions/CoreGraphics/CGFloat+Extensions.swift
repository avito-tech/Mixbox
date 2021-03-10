#if MIXBOX_ENABLE_IN_APP_SERVICES

import CoreGraphics

extension CGFloat {
    public func mb_ceil() -> CGFloat {
        return CoreGraphics.ceil(self)
    }
    
    public func mb_floor() -> CGFloat {
        return CoreGraphics.floor(self)
    }
}

#endif
