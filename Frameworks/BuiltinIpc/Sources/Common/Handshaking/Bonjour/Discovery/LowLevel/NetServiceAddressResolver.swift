#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

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
