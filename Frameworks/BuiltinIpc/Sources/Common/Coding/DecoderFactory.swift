#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol DecoderFactory: class {
    func decoder() -> JSONDecoder
}

#endif
