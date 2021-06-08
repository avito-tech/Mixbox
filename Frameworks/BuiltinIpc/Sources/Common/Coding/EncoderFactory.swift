#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol EncoderFactory: AnyObject {
    func encoder() -> JSONEncoder
}

#endif
