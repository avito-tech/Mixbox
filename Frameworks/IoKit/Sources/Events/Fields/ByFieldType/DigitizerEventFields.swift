#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class DigitizerEventFields {
    private let fields: EventFieldsByValueType
    
    public init(fields: EventFieldsByValueType) {
        self.fields = fields
    }
    
    public var isDisplayIntegrated: Bool {
        get { return fields.integer[.digitizerIsDisplayIntegrated] }
        set { fields.integer[.digitizerIsDisplayIntegrated] = newValue }
    }
}

#endif
