#if MIXBOX_ENABLE_IN_APP_SERVICES

// Replicates registration functions of URLProtocol, see BridgedUrlProtocolRegisterer
public protocol RegisteredBridgedUrlProtocolClass: AnyObject {
    func unregister() throws
}

#endif
