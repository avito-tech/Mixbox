#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

#if SWIFT_PACKAGE
import MixboxIoKitObjc
#endif

public final class EventFieldsByValueType {
    public let integer: EventIntegerFields
    public let float: EventFloatFields
    public let position: EventPositionFields
    
    public init(iohidEventRef: IOHIDEventRef) {
        integer = EventIntegerFields(iohidEventRef: iohidEventRef)
        float = EventFloatFields(iohidEventRef: iohidEventRef)
        position = EventPositionFields(iohidEventRef: iohidEventRef)
    }
}

#endif
