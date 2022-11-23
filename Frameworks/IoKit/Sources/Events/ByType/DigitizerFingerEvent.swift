#if MIXBOX_ENABLE_FRAMEWORK_IO_KIT && MIXBOX_DISABLE_FRAMEWORK_IO_KIT
#error("IoKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IO_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IO_KIT)
// The compilation is disabled
#else

import MixboxFoundation

public final class DigitizerFingerEvent: BaseDigitizerEvent {
    public let iohidEventRef: IOHIDEventRef
    
    public init(iohidEventRef: IOHIDEventRef) {
        self.iohidEventRef = iohidEventRef
    }
    
    // swiftlint:disable:next function_parameter_count
    public convenience init(
        allocator: CFAllocator?,
        timeStamp: AbsoluteTime,
        index: UInt32,
        identity: UInt32,
        eventMask: DigitizerEventMask,
        x: Double,
        y: Double,
        z: Double,
        tipPressure: Double,
        twist: Double,
        range: Bool,
        touch: Bool,
        options: EventOptionBits)
    {
        self.init(
            iohidEventRef: IOHIDEventCreateDigitizerFingerEvent(
                allocator,
                timeStamp.darwinAbsoluteTime,
                index,
                identity,
                eventMask.iohidDigitizerEventMask,
                x,
                y,
                z,
                tipPressure,
                twist,
                range,
                touch,
                options.iohidEventOptionBits
            )
        )
    }
}

#endif
