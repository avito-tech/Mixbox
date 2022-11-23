#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

public final class EventPositionFields {
    private let iohidEventRef: IOHIDEventRef
    
    public init(iohidEventRef: IOHIDEventRef) {
        self.iohidEventRef = iohidEventRef
    }
    
    public subscript(_ field: IOHIDEventField) -> IOHID3DPoint {
        get {
            return IOHIDEventGetPosition(iohidEventRef, field)
        }
        set {
            return IOHIDEventSetPosition(iohidEventRef, field, newValue)
        }
    }
}

#endif
