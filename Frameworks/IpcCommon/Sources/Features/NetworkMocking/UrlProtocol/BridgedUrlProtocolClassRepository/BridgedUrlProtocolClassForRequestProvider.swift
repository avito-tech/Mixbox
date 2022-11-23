#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxFoundation

public protocol BridgedUrlProtocolClassForRequestProvider: AnyObject {
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
