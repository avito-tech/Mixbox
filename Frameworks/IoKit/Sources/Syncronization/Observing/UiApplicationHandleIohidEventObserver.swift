#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

import Foundation

#if SWIFT_PACKAGE
import MixboxIoKitObjc
#endif

public final class UiApplicationHandleIohidEventObserver: Hashable {
    public let uiApplicationHandledIohidEvent: (_ iohidEvent: IOHIDEventRef) -> ()
    private let uniqueNumberForHash: UInt32
    
    public init(
        uiApplicationHandledIohidEvent: @escaping (_ iohidEvent: IOHIDEventRef) -> ())
    {
        self.uiApplicationHandledIohidEvent = uiApplicationHandledIohidEvent
        self.uniqueNumberForHash = arc4random()
    }
    
    public static func == (lhs: UiApplicationHandleIohidEventObserver, rhs: UiApplicationHandleIohidEventObserver) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueNumberForHash)
    }
}

#endif
