#if MIXBOX_ENABLE_IN_APP_SERVICES

// Makes everything to make MixboxUrlProtocol work (custom URLProtocol)
public protocol MixboxUrlProtocolBootstrapper: AnyObject {
    func bootstrapNetworkMocking()
}

#endif
