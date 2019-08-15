#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol EncoderFactory: class {
    func encoder() -> JSONEncoder
}

#endif
