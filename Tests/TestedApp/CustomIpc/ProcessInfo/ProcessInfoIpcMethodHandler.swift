import MixboxIpc
import TestsIpc
import Foundation

final class ProcessInfoIpcMethodHandler: IpcMethodHandler {
    let method = ProcessInfoIpcMethod()
    
    func handle(arguments: IpcVoid, completion: @escaping (IpcProcessInfo) -> ()) {
        let processInfo = ProcessInfo.processInfo
        
        let ipcProcessInfo = IpcProcessInfo(
            environment: processInfo.environment,
            arguments: processInfo.arguments,
            hostName: processInfo.hostName,
            processName: processInfo.processName,
            processIdentifier: processInfo.processIdentifier
        )
        
        completion(ipcProcessInfo)
    }
}
