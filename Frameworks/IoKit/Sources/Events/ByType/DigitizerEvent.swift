#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

// TODO: Make it struct & support COW via `isKnownUniquelyReferenced`
// https://developer.apple.com/documentation/swift/2429905-isknownuniquelyreferenced
// Same for other events.
public final class DigitizerEvent: Event {
    public let allocator: CFAllocator?
    public let timeStamp: AbsoluteTime
    public let transducer: IOHIDDigitizerTransducerType
    public let index: UInt32
    public let identifier: UInt32
    public let eventMask: IOHIDDigitizerEventMask
    public let buttonEvent: UInt32
    public let x: IOHIDFloat
    public let y: IOHIDFloat
    public let z: IOHIDFloat
    public let tipPressure: IOHIDFloat
    public let twist: IOHIDFloat
    public let range: Bool
    public let touch: Bool
    public let options: IOHIDEventOptionBits
    
    public private(set) var iohidEventRef: IOHIDEventRef
    
    // swiftlint:disable:next function_parameter_count
    public init(
        allocator: CFAllocator?,
        timeStamp: AbsoluteTime,
        transducer: IOHIDDigitizerTransducerType,
        index: UInt32,
        identifier: UInt32,
        eventMask: IOHIDDigitizerEventMask,
        buttonEvent: UInt32,
        x: IOHIDFloat,
        y: IOHIDFloat,
        z: IOHIDFloat,
        tipPressure: IOHIDFloat,
        twist: IOHIDFloat,
        range: Bool,
        touch: Bool,
        options: IOHIDEventOptionBits)
    {
        self.allocator = allocator
        self.timeStamp = timeStamp
        self.transducer = transducer
        self.index = index
        self.identifier = identifier
        self.eventMask = eventMask
        self.buttonEvent = buttonEvent
        self.x = x
        self.y = y
        self.z = z
        self.tipPressure = tipPressure
        self.twist = twist
        self.range = range
        self.touch = touch
        self.options = options
        
        iohidEventRef = IOHIDEventCreateDigitizerEvent(
            allocator,
            timeStamp.cAbsoluteTime,
            transducer,
            index,
            identifier,
            eventMask,
            buttonEvent,
            x,
            y,
            z,
            tipPressure,
            twist,
            range,
            touch,
            options
        )
    }
}

#endif
