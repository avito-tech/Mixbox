#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol BridgedUrlProtocolClassRepository: AnyObject {
    func add(bridgedUrlProtocolClass: BridgedUrlProtocolClass)
    func remove(bridgedUrlProtocolClass: BridgedUrlProtocolClass)
}

#endif
