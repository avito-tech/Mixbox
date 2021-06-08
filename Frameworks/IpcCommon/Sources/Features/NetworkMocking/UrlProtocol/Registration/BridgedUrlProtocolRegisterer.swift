#if MIXBOX_ENABLE_IN_APP_SERVICES

// Replicates registration functions of URLProtocol
public protocol BridgedUrlProtocolRegisterer: AnyObject {
    func register(
        bridgedUrlProtocolClass: BridgedUrlProtocolClass & IpcObjectIdentifiable)
        throws
        -> RegisteredBridgedUrlProtocolClass
}

#endif
