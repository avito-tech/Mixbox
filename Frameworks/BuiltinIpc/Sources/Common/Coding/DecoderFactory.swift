#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol DecoderFactory: AnyObject {
    func decoder() -> JSONDecoder
}

#endif
