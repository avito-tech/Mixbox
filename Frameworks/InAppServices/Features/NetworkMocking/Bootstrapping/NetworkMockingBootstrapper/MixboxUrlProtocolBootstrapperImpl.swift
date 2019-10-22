#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxIpc
import MixboxIpcCommon

public final class MixboxUrlProtocolBootstrapperImpl: MixboxUrlProtocolBootstrapper {
    private let assertingSwizzler: AssertingSwizzler
    private let mixboxUrlProtocolDependenciesFactory: MixboxUrlProtocolDependenciesFactory
    private let mixboxUrlProtocolSpecificIpcMethodHandlersRegisterer: IpcMethodHandlersRegisterer
    private let ipcRouter: IpcRouter
    private let onceToken = ThreadUnsafeOnceToken<Void>()
    
    public init(
        assertingSwizzler: AssertingSwizzler,
        mixboxUrlProtocolDependenciesFactory: MixboxUrlProtocolDependenciesFactory,
        mixboxUrlProtocolSpecificIpcMethodHandlersRegisterer: IpcMethodHandlersRegisterer,
        ipcRouter: IpcRouter)
    {
        self.assertingSwizzler = assertingSwizzler
        self.mixboxUrlProtocolDependenciesFactory = mixboxUrlProtocolDependenciesFactory
        self.mixboxUrlProtocolSpecificIpcMethodHandlersRegisterer = mixboxUrlProtocolSpecificIpcMethodHandlersRegisterer
        self.ipcRouter = ipcRouter
    }
    
    public func bootstrapNetworkMocking() {
        _ = onceToken.executeOnce {
            bootstrapNetworkMockingWhileBeingExecutedOnce()
        }
    }
    
    public func bootstrapNetworkMockingWhileBeingExecutedOnce() {
        assertingSwizzler.swizzle(
            class: URLSessionConfiguration.self,
            originalSelector: #selector(getter: URLSessionConfiguration.default),
            swizzledSelector: #selector(URLSessionConfiguration.swizzled_MixboxUrlProtocolBootstrapperImpl_default),
            methodType: .classMethod,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
        
        assertingSwizzler.swizzle(
            class: URLSessionConfiguration.self,
            originalSelector: #selector(getter: URLSessionConfiguration.ephemeral),
            swizzledSelector: #selector(URLSessionConfiguration.swizzled_MixboxUrlProtocolBootstrapperImpl_ephemeral),
            methodType: .classMethod,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
        
        MixboxUrlProtocol.register(
            dependencies: mixboxUrlProtocolDependenciesFactory.mixboxUrlProtocolClassDependencies()
        )
        
        mixboxUrlProtocolSpecificIpcMethodHandlersRegisterer.registerIn(ipcRouter: ipcRouter)
    }
}

extension URLSessionConfiguration {
    @objc fileprivate class func swizzled_MixboxUrlProtocolBootstrapperImpl_default() -> URLSessionConfiguration {
        return swizzled_MixboxUrlProtocolBootstrapperImpl_default()
            .byAddingMixboxUrlProtocol()
    }
    
    @objc fileprivate class func swizzled_MixboxUrlProtocolBootstrapperImpl_ephemeral() -> URLSessionConfiguration {
        return swizzled_MixboxUrlProtocolBootstrapperImpl_ephemeral()
            .byAddingMixboxUrlProtocol()
    }
    
    private func byAddingMixboxUrlProtocol() -> URLSessionConfiguration {
        let protocolClasses = self.protocolClasses ?? []
        
        let shouldInsertClass = !protocolClasses.contains { protocolClass in
            protocolClass === MixboxUrlProtocol.self
        }
        
        if shouldInsertClass {
            // Inserting at the beginning is important, because it will override default URLProtocol
            self.protocolClasses = [MixboxUrlProtocol.self] + protocolClasses
        }
        
        return self
    }
}

#endif
