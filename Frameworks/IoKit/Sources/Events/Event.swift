#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol Event {
    var iohidEventRef: IOHIDEventRef { get }
}

extension Event {
    public var digitizer: DigitizerEventFields {
        return DigitizerEventFields(fields: fields)
    }
    
    public var vendorDefined: VendorDefinedEventFields {
        return VendorDefinedEventFields(fields: fields)
    }
    
    // NOTE: Prefer using digitizer/vendorDefined, because they are type safe
    // (some fields can only be int, some double, etc).
    public var fields: EventFieldsByValueType {
        return EventFieldsByValueType(iohidEventRef: iohidEventRef)
    }
}

extension Event {
    public func append(event: Event, options: IOOptionBits) {
        IOHIDEventAppendEvent(iohidEventRef, event.iohidEventRef, options)
    }
}

#endif
