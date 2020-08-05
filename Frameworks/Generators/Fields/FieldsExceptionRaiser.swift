#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class FieldsExceptionRaiser {
    private init() {
    }
    
    public static func raiseException(message: String) -> Never {
        let exception = NSException(
            name: NSExceptionName(rawValue: "FieldsException"),
            reason: message,
            userInfo: nil
        )
        
        exception.raise()
        fatalError(message)
    }
}

#endif
