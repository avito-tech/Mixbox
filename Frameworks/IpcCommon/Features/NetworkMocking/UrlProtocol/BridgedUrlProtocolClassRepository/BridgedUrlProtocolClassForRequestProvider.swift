#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public protocol BridgedUrlProtocolClassForRequestProvider: class {
    func bridgedUrlProtocolClass(
        forRequest: BridgedUrlRequest)
        throws
        -> BridgedUrlProtocolClass
}

extension BridgedUrlProtocolClassForRequestProvider {
    public func bridgedUrlProtocolClassWithFunctionDescription(
        forRequest request: BridgedUrlRequest,
        function: StaticString = #function)
        throws
        -> BridgedUrlProtocolClass
    {
        do {
            return try bridgedUrlProtocolClass(forRequest: request)
        } catch {
            throw ErrorString(
                """
                Failed to provide bridgedUrlProtocolClass for request \(request) \
                while calling function \(function): \(error)
                """
            )
        }
    }
}

#endif
