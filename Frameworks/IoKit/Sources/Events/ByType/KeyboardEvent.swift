#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class KeyboardEvent: Event {
    public let iohidEventRef: IOHIDEventRef
    
    public var usagePage: Int32 {
        get { return fields.integer[.vendorDefinedUsagePage] }
        set { fields.integer[.vendorDefinedUsagePage] = newValue }
    }
    // TODO:
    //    kIOHIDEventFieldVendorDefinedUsagePage = IOHIDEventFieldBase(kIOHIDEventTypeVendorDefined),
    //    kIOHIDEventFieldVendorDefinedReserved,
    //    kIOHIDEventFieldVendorDefinedReserved1,
    //    kIOHIDEventFieldVendorDefinedDataLength,
    //    kIOHIDEventFieldVendorDefinedData
    
    public init(iohidEventRef: IOHIDEventRef) {
        self.iohidEventRef = iohidEventRef
    }
    
    public convenience init(
        allocator: CFAllocator?,
        timeStamp: AbsoluteTime,
        usagePage: UInt16,
        usage: UInt16,
        down: Bool,
        options: EventOptionBits)
    {
        self.init(
            iohidEventRef: IOHIDEventCreateKeyboardEvent(
                allocator,
                timeStamp.darwinAbsoluteTime,
                usagePage,
                usage,
                down,
                options.iohidEventOptionBits
            )
        )
    }
}

#endif
