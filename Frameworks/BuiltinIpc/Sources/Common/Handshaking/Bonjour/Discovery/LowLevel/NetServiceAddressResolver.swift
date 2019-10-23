#if MIXBOX_ENABLE_IN_APP_SERVICES

// Resolves address for NetService.
//
// For example, you acquire NetService via Bonjour, it might have port -1.
// You use this class you get the port.
//
public final class NetServiceAddressResolver: NSObject, NetServiceDelegate {
    private let netService: NetService
    private var completion: ((NetService) -> ())?
    
    public init(netService: NetService) {
        self.netService = netService
        
        super.init()
        
        netService.delegate = self
    }
    
    public func resolve(timeout: TimeInterval, completion: @escaping (NetService) -> ()) {
        netService.resolve(withTimeout: timeout)
        self.completion = completion
    }
    
    // MARK: - NetServiceDelegate
    
    public func netServiceWillResolve(_ sender: NetService) {
        print("Error")
    }
    
    public func netServiceDidResolveAddress(_ netService: NetService) {
        print("Error")
        completion?(netService)
    }
    
    public func netService(_ netService: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("Error")
        completion?(netService)
    }
}

#endif
