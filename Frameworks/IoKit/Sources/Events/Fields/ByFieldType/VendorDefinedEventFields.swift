#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class VendorDefinedEventFields {
    private let fields: EventFieldsByValueType
    
    public init(fields: EventFieldsByValueType) {
        self.fields = fields
    }
    
    public var usagePage: Int32 {
        get { return fields.integer[.vendorDefinedUsagePage] }
        set { fields.integer[.vendorDefinedUsagePage] = newValue }
    }
    
//    kIOHIDEventFieldVendorDefinedUsagePage = IOHIDEventFieldBase(kIOHIDEventTypeVendorDefined),
//    kIOHIDEventFieldVendorDefinedReserved,
//    kIOHIDEventFieldVendorDefinedReserved1,
//    kIOHIDEventFieldVendorDefinedDataLength,
//    kIOHIDEventFieldVendorDefinedData
}

#endif
