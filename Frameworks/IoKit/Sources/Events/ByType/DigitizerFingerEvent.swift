#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class DigitizerFingerEvent: Event {
    public let allocator: CFAllocator?
    public let timeStamp: AbsoluteTime
    public let index: UInt32
    public let identifier: UInt32
    public let eventMask: IOHIDDigitizerEventMask
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
        index: UInt32,
        identifier: UInt32,
        eventMask: IOHIDDigitizerEventMask,
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
        self.index = index
        self.identifier = identifier
        self.eventMask = eventMask
        self.x = x
        self.y = y
        self.z = z
        self.tipPressure = tipPressure
        self.twist = twist
        self.range = range
        self.touch = touch
        self.options = options
        
        iohidEventRef = IOHIDEventCreateDigitizerFingerEvent(
            allocator,
            timeStamp.cAbsoluteTime,
            index,
            identifier,
            eventMask,
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
