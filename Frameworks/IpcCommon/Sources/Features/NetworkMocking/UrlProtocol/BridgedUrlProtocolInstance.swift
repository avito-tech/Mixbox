#if MIXBOX_ENABLE_IN_APP_SERVICES

// Replicates instance object of URLProtocol
public protocol BridgedUrlProtocolInstance: AnyObject {
    func startLoading() throws
    func stopLoading() throws
    
    // Not implemented:
    //
    // func property(forKey key: String, in request: URLRequest) -> Any?
    // func setProperty(_ value: Any, forKey key: String, in request: NSMutableURLRequest)
    // func removeProperty(forKey key: String, in request: NSMutableURLRequest)
}

#endif
