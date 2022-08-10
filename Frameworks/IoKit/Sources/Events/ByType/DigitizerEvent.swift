#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

// TODO: Make it struct & support COW via `isKnownUniquelyReferenced`
// https://developer.apple.com/documentation/swift/2429905-isknownuniquelyreferenced
// Same for other events.
public final class DigitizerEvent: BaseDigitizerEvent {
    public let iohidEventRef: IOHIDEventRef
    
    public init(iohidEventRef: IOHIDEventRef) {
        self.iohidEventRef = iohidEventRef
    }
    
    // swiftlint:disable:next function_parameter_count
    public convenience init(
        allocator: CFAllocator?,
        timeStamp: AbsoluteTime,
        transducer: DigitizerTransducerType,
        index: UInt32,
        identity: UInt32,
        eventMask: DigitizerEventMask,
        buttonMask: ButtonMask,
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
            iohidEventRef: IOHIDEventCreateDigitizerEvent(
                allocator,
                timeStamp.darwinAbsoluteTime,
                transducer.iohidDigitizerTransducerType,
                index,
                identity,
                eventMask.iohidDigitizerEventMask,
                buttonMask,
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
        
        // Very strange thing. Option bits after `IOHIDEventCreateDigitizerEvent` are equal to (options bits || 0x20000)
        // It was expected that options of iohid event will equal to those passed via constructor.
        // Note: 0x20000 is either `keyboard.stickyKeyDown` or `transducer.touch` (see `EventOptionBits`)
        if self.options != options {
            // TODO: Assert that this worked
            self.options = options
        }
        
        if self.range != range {
            self.range = range
        }
        
        if self.touch != touch {
            self.touch = touch
        }
    }
}

#endif
