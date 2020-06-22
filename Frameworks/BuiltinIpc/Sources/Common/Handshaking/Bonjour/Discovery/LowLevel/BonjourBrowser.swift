#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import Foundation

// Finds services (uses Foundations's NetService type) via Bonjour.
//
// Usage:
//
//  try bonjourBrowser.start(
//      onServiceFound: { [weak self] service in
//          self?.resolve(service: service)
//      },
//      onServiceLost: { [weak self] service in
//          self?.remove(service: service)
//      }
//  )
//
public final class BonjourBrowser: NSObject, NetServiceBrowserDelegate {
    private enum State {
        case stopped
        case started(StartedState)
    }
    
    public typealias OnServiceFound = (NetService) -> ()
    public typealias OnServiceLost = (NetService) -> ()
    
    private struct StartedState {
        let browser: NetServiceBrowser
        let onServiceFound: OnServiceFound
        let onServiceLost: OnServiceLost
    }
    
    private var state: State = .stopped
    
    public func start(
        onServiceFound: @escaping OnServiceFound,
        onServiceLost: @escaping OnServiceLost)
        throws
    {
        switch state {
        case .stopped:
            state = .started(
                startedState(
                    onServiceFound: onServiceFound,
                    onServiceLost: onServiceLost
                )
            )
        case .started:
            throw ErrorString("Invalid transition from state \(state) to 'started'")
        }
    }
    
    public func stop() throws {
        switch state {
        case .stopped:
            throw ErrorString("Invalid transition from state \(state) to 'stopped'")
        case .started(let startedState):
            startedState.browser.stop()
            state = .stopped
        }
    }
    
    // MARK: - NetServiceBrowserDelegate
    
    public func netServiceBrowser(
        _ browser: NetServiceBrowser,
        didFind service: NetService,
        moreComing: Bool)
    {
        try? add(service: service)
    }
    
    public func netServiceBrowser(
        _ browser: NetServiceBrowser,
        didRemove service: NetService,
        moreComing: Bool)
    {
        try? remove(service: service)
    }
    
    public func netServiceBrowserWillSearch(
        _ browser: NetServiceBrowser)
    {
    }
    
    public func netServiceBrowserDidStopSearch(
        _ browser: NetServiceBrowser)
    {
    }
    
    public func netServiceBrowser(
        _ browser: NetServiceBrowser,
        didNotSearch errorDict: [String : NSNumber])
    {
    }
    
    public func netServiceBrowser(
        _ browser: NetServiceBrowser,
        didFindDomain domainString: String,
        moreComing: Bool)
    {
    }
    
    public func netServiceBrowser(
        _ browser: NetServiceBrowser,
        didRemoveDomain domainString: String,
        moreComing: Bool)
    {
    }
    
    // MARK: - Private
    
    private func startedState(
        onServiceFound: @escaping OnServiceFound,
        onServiceLost: @escaping OnServiceLost)
        -> StartedState
    {
        let browser = NetServiceBrowser()
        browser.delegate = self
        browser.searchForServices(
            ofType: Constants.bonjourServiceType,
            inDomain: Constants.bonjourServiceDomain
        )
        
        return StartedState(
            browser: browser,
            onServiceFound: onServiceFound,
            onServiceLost: onServiceLost
        )
    }
    
    private func add(service: NetService) throws {
        switch state {
        case .stopped:
            throw ErrorString("Invalid state \(state) when calling add(service:)")
        case .started(let startedState):
            startedState.onServiceFound(service)
        }
    }
    
    private func remove(service: NetService) throws {
        switch state {
        case .stopped:
            throw ErrorString("Invalid state \(state) when calling remove(service:)")
        case .started(let startedState):
            startedState.onServiceLost(service)
        }
    }
}

#endif
