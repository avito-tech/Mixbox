#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxFoundation
#if SWIFT_PACKAGE
import SBTUITestTunnelServer
import SBTUITestTunnelCommon
#else
import SBTUITestTunnel
#endif
final class SbtuiCustomCommand {
    private typealias HandleFunction = (_ request: NSObject?) -> (NSObject?)
    
    private let handleFunction: HandleFunction
    private let name: String
    
    init<MethodHandler: IpcMethodHandler>(ipcMethodHandler: MethodHandler) {
        handleFunction = { request in
            try? SbtuiCustomCommand.handle(request: request, usingIpcMethodHandler: ipcMethodHandler)
        }
        name = ipcMethodHandler.method.name
    }
    
    func register() {
        SBTUITestTunnelServer.registerCustomCommandNamed(sbtuiTestTunnelCommandName()) { [weak self] request in
            self?.handleFunction(request)
        }
    }
    
    func unregister() {
        SBTUITestTunnelServer.unregisterCommandNamed(sbtuiTestTunnelCommandName())
    }
    
    private func sbtuiTestTunnelCommandName() -> String {
        return "customCommand:\(name)"
    }
    
    private static func handle<MethodHandler: IpcMethodHandler>(
        request: NSObject?,
        usingIpcMethodHandler ipcMethodHandler: MethodHandler)
        throws
        -> NSObject
    {
        let typedArguments: MethodHandler.Method.Arguments = try decodeArguments(
            sbtuiRequestOrNil: request
        )
        
        var typedReturnValueOrNil: MethodHandler.Method.ReturnValue?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        ipcMethodHandler.handle(arguments: typedArguments) { returnValue in
            typedReturnValueOrNil = returnValue
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        
        guard let typedReturnValue = typedReturnValueOrNil else {
            throw ErrorString("Internal error: ipcMethodHandler did not handle method")
        }
        
        return try encodeReturnValue(sbtuiResult: typedReturnValue)
    }
    
    private static func decodeArguments<T: Codable>(
        sbtuiRequestOrNil: NSObject?)
        throws
        -> T
    {
        guard let sbtuiRequest = sbtuiRequestOrNil else {
            throw ErrorString("sbtuiRequest is nil")
        }
        
        guard let serializedArguments = sbtuiRequest as? String else {
            throw ErrorString("sbtuiRequest is not String: \(sbtuiRequest)")
        }
        
        return try GenericSerialization.deserialize(string: serializedArguments)
    }
    
    private static func encodeReturnValue<T: Codable>(
        sbtuiResult: T)
        throws
        -> NSObject
    {
        return try GenericSerialization.serialize(value: sbtuiResult) as NSObject
    }
}

#endif
