#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class KeyboardEvent: Event {
    public let allocator: CFAllocator?
    public let timeStamp: AbsoluteTime
    public let usagePage: UInt16
    public let usage: UInt16
    public let down: Bool
    public let optionBits: IOHIDEventOptionBits
    
    public private(set) var iohidEventRef: IOHIDEventRef
    
    // swiftlint:disable:next function_parameter_count
    public init(
        allocator: CFAllocator?,
        timeStamp: AbsoluteTime,
        usagePage: UInt16,
        usage: UInt16,
        down: Bool,
        optionBits: IOHIDEventOptionBits)
    {
        self.allocator = allocator
        self.timeStamp = timeStamp
        self.usagePage = usagePage
        self.usage = usage
        self.down = down
        self.optionBits = optionBits
        
        iohidEventRef = IOHIDEventCreateKeyboardEvent(
            allocator,
            timeStamp.cAbsoluteTime,
            usagePage,
            usage,
            down,
            optionBits
        )
    }
}

#endif
