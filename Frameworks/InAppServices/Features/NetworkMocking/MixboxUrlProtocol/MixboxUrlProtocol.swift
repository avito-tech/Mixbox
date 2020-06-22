#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxIpcCommon
import Foundation

public class MixboxUrlProtocol: URLProtocol {
    // There are sigletons everywhere when we are working with URLProtocol.
    // So we have to use singletons. The possible solution to get rid of signletons is to create class
    // at runtime with injected dependencies, but it is too complex and error prone.
    private static var dependencies: MixboxUrlProtocolDependencies?
    
    private var bridgedUrlProtocolInstanceProvider: BridgedUrlProtocolInstanceProvider?
    
    override public init(
        request: URLRequest,
        cachedResponse: CachedURLResponse?,
        client: URLProtocolClient?)
    {
        if let dependencies = MixboxUrlProtocol.dependencies {
            bridgedUrlProtocolInstanceProvider = BridgedUrlProtocolInstanceProvider(
                urlRequest: request,
                cachedUrlResponse: cachedResponse,
                urlProtocolClient: client,
                bridgedUrlProtocolClass: dependencies.bridgedUrlProtocolClass,
                urlRequestBridging: dependencies.urlRequestBridging,
                urlResponseBridging: dependencies.urlResponseBridging,
                cachedUrlResponseBridging: dependencies.cachedUrlResponseBridging,
                urlCacheStoragePolicyBridging: dependencies.urlCacheStoragePolicyBridging
            )
        } else {
            bridgedUrlProtocolInstanceProvider = nil
        }
        
        super.init(
            request: request,
            cachedResponse: cachedResponse,
            client: client
        )
    }
    
    // MARK: - MixboxUrlProtocol
    
    // Should be called once
    public static func register(dependencies: MixboxUrlProtocolDependencies) {
        self.dependencies = dependencies
        
        URLProtocol.registerClass(MixboxUrlProtocol.self)
    }
    
    // MARK: - URLProtocol / Class functions
  
    override public class func canInit(with request: URLRequest) -> Bool {
        do {
            let dependencies = try getDependenciesOrThrow()
            
            let bridgedUrlRequest = try dependencies.urlRequestBridging.bridgedUrlRequest(urlRequest: request)
            
            return try dependencies.bridgedUrlProtocolClass.canInit(with: bridgedUrlRequest)
        } catch {
            recordFailure(
                fallbackAction: "Returning `false`",
                error: error
            )
            
            return false
        }
    }
    
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        do {
            let dependencies = try getDependenciesOrThrow()
            
            let bridgedRequest = try dependencies.urlRequestBridging.bridgedUrlRequest(
                urlRequest: request
            )
            let bridgedCanonicalRequest = try dependencies.bridgedUrlProtocolClass.canonicalRequest(
                for: bridgedRequest
            )
            let canonicalRequest = try dependencies.urlRequestBridging.urlRequest(
                bridgedUrlRequest: bridgedCanonicalRequest
            )
            
            return canonicalRequest
        } catch {
            recordFailure(
                fallbackAction: "Returning same request",
                error: error
            )
            
            return request
        }
    }
    
    // MARK: - URLProtocol / Instance functions
    
    override public func startLoading() {
        do {
            let instance = try getBridgedUrlProtocolInstanceOrThrow()
            
            try instance.startLoading()
        } catch {
            recordFailureAndFailRequest(
                error: error
            )
        }
    }
    
    override public func stopLoading() {
        do {
            let instance = try getBridgedUrlProtocolInstanceOrThrow()
            
            try instance.stopLoading()
        } catch {
            recordFailureAndFailRequest(
                error: error
            )
        }
    }
    
    // MARK: - Private
    
    private static func getDependenciesOrThrow() throws -> MixboxUrlProtocolDependencies {
        guard let dependencies = dependencies else {
            throw uwrappingErrorDueToNotInjectedDependencies(fieldName: "dependencies")
        }
        
        return dependencies
    }
    
    private func getBridgedUrlProtocolInstanceOrThrow() throws -> BridgedUrlProtocolInstance {
        guard let bridgedUrlProtocolInstanceProvider = bridgedUrlProtocolInstanceProvider else {
            throw MixboxUrlProtocol.uwrappingErrorDueToNotInjectedDependencies(
                fieldName: "bridgedUrlProtocolInstanceProvider"
            )
        }
        
        let instance = try bridgedUrlProtocolInstanceProvider.bridgedUrlProtocolInstance(
            urlProtocol: self
        )
        
        return instance
    }
    
    private func recordFailureAndFailRequest(
        error: Error,
        function: String = #function)
    {
        let clientIsNilNotice = client == nil
            ? " (note that `client` is nil)"
            : ""
        
        let failureMessage = MixboxUrlProtocol.recordFailure(
            fallbackAction: "Failing request by calling client's urlProtocol(_:didFailWithError:)\(clientIsNilNotice)",
            error: error,
            function: function
        )
        
        client?.urlProtocol(self, didFailWithError: ErrorString(failureMessage))
    }
    
    @discardableResult
    private static func recordFailure(
        argumentsDescription: String? = nil,
        fallbackAction: String,
        error: Error,
        function: String = #function)
        -> String
    {
        let argumentsDescriptionInfix = argumentsDescription.map { " for \($0)" } ?? ""
        
        let failureMessage =
        """
        Failed to call \(function)\(argumentsDescriptionInfix). \(fallbackAction). Nested error: \(error)
        """
        
        guard let dependencies = dependencies else {
            // We can't record failure
            return failureMessage
        }
        
        dependencies.assertionFailureRecorder.recordAssertionFailure(
            message: failureMessage
        )
        
        return failureMessage
    }
    
    private static func uwrappingErrorDueToNotInjectedDependencies(fieldName: String) -> Error {
        return ErrorString(
            """
            Unexpectedly found nil while unwrapping optional `\(fieldName)`. \
            Did you forget to inject `dependencies` into `MixboxUrlProtocol`?
            """
        )
    }
}

#endif
