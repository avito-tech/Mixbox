import Foundation
import MixboxIpc
import MixboxIpcCommon

public protocol DeepLinkOpener: class {
    func openDeepLink(_ deepLinkUri: String) -> IpcMethodCallingResult
}

public final class DeepLinkOpenerImpl: DeepLinkOpener {
    private let ipcClient: IpcClient
    
    public init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    public func openDeepLink(_ deepLinkUri: String) -> IpcMethodCallingResult {
        let result = ipcClient.call(
            method: OpenUrlIpcMethod(),
            arguments: deepLinkUri
        )
        
        switch result {
        case .data(let data):
            return data
        case .error:
            return .failure("Не удалось получить ответ от аппа")
        }
    }
}
