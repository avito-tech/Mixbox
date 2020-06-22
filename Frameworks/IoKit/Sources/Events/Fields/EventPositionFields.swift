#if MIXBOX_ENABLE_IN_APP_SERVICES
import MixboxIoKit_objc

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
