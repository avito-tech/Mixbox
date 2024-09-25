#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

#if SWIFT_PACKAGE
import MixboxIoKitObjc
#endif

public final class EventIntegerFields {
    private let iohidEventRef: IOHIDEventRef
    
    public init(iohidEventRef: IOHIDEventRef) {
        self.iohidEventRef = iohidEventRef
    }
    
    public subscript(_ field: IOHIDEventField) -> Int32 {
        get {
            return IOHIDEventGetIntegerValue(iohidEventRef, field)
        }
        set {
            IOHIDEventSetIntegerValue(iohidEventRef, field, newValue)
        }
    }
    
    public subscript(_ field: IOHIDEventField) -> UInt32 {
        get {
            return UInt32(bitPattern: self[field])
        }
        set {
            self[field] = Int32(bitPattern: newValue)
        }
    }
    
    public subscript(_ field: IOHIDEventField) -> Bool {
        get {
            return IOHIDEventGetIntegerValue(iohidEventRef, field) != 0
        }
        set {
            IOHIDEventSetIntegerValue(iohidEventRef, field, newValue ? 1 : 0)
        }
    }
}

#endif
