#if MIXBOX_ENABLE_IN_APP_SERVICES

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
