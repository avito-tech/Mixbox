#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxFoundation

// Finds specific Bonjour service, resolves address.
public final class BonjourIpcServiceDiscoverer {
    private let bonjourBrowser = BonjourBrowser()
    private let bonjourServiceSettings: BonjourServiceSettings
    private var netServiceAddressResolver: NetServiceAddressResolver?
    
    public var onServiceFound: ((BonjourIpcService, [BonjourIpcService]) -> ())?
    public var onServiceLost: ((BonjourIpcService, [BonjourIpcService]) -> ())?
    
    private var serviceStateById = [NetServiceId: BonjourIpcServiceState]()
    
    private let callbackQueue = DispatchQueue(label: "BonjourIpcServiceDiscoverer.callbackQueue")
    
    private enum BonjourIpcServiceState {
        case resolving(NetService, NetServiceAddressResolver)
        case resolvingFailed(NetService)
        case resolved(BonjourIpcService)
        case lost
    }
    
    private final class NetServiceId: Hashable {
        private let netService: NetService
        
        init(netService: NetService) {
            self.netService = netService
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(netService)
        }
        
        static func ==(left: NetServiceId, right: NetServiceId) -> Bool {
            return left.netService.isEqual(right.netService)
        }
    }
    
    public init(bonjourServiceSettings: BonjourServiceSettings) {
        self.bonjourServiceSettings = bonjourServiceSettings
    }
    
    public func startDiscovery() throws {
        try bonjourBrowser.start(
            onServiceFound: { [weak self] service in
                self?.resolve(service: service)
            },
            onServiceLost: { [weak self] service in
                self?.remove(service: service)
            }
        )
    }
    
    private func resolve(
        service: NetService)
    {
        guard serviceMatches(service: service) else {
            return
        }
        
        let netServiceAddressResolver = NetServiceAddressResolver(netService: service)
        
        callbackQueue.async { [weak self] in
            self?.setBonjourIpcServiceState(
                service: service,
                state: .resolving(service, netServiceAddressResolver)
            )
        }
        
        netServiceAddressResolver.resolve(timeout: 10) { [weak self] service in
            self?.handleResolved(service: service)
        }
    }
    
    private func remove(
        service: NetService)
    {
        guard serviceMatches(service: service) else {
            return
        }
        
        callbackQueue.async { [weak self] in
            self?.setBonjourIpcServiceState(
                service: service,
                state: .lost
            )
        }
    }
    
    private func handleResolved(
        service: NetService)
    {
        callbackQueue.async { [weak self] in
            self?.handleResolvedWhileBeingOnCallbackQueue(service: service)
        }
    }
    
    private func handleResolvedWhileBeingOnCallbackQueue(
        service: NetService)
    {
        let id = NetServiceId(netService: service)
        
        if let oldState = serviceStateById[id] {
            switch oldState {
            case .resolving(let existingService, _):
                if existingService === service {
                    let newState: BonjourIpcServiceState
                    
                    if let host = service.hostName, service.port > 0 {
                        newState = .resolved(
                            BonjourIpcService(
                                host: host,
                                port: UInt(service.port)
                            )
                        )
                    } else {
                        newState = .resolvingFailed(service)
                    }
                    
                    setBonjourIpcServiceState(
                        service: service,
                        state: newState
                    )
                }
            case .resolved, .resolvingFailed, .lost:
                break
            }
        }
    }
    
    private func setBonjourIpcServiceState(service: NetService, state: BonjourIpcServiceState) {
        let id = NetServiceId(netService: service)
        let oldState = serviceStateById[id]
        
        serviceStateById[id] = state
        
        switch (oldState, state) {
        case let (.resolved(service)?, _):
            onServiceLost?(service, allServices())
        case let (_, .resolved(service)):
            onServiceFound?(service, allServices())
        default:
            break
        }
    }
    
    private func allServices() -> [BonjourIpcService] {
        return serviceStateById.values.compactMap { state in
            switch state {
            case let .resolved(service):
                return service
            default:
                return nil
            }
        }
    }
    
    private func serviceMatches(service: NetService) -> Bool {
        return service.name == bonjourServiceSettings.name
            && service.type == Constants.bonjourServiceType
    }
}

#endif
