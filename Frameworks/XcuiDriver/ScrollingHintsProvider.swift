import MixboxIpcCommon
import MixboxIpcClients
import MixboxIpc
import MixboxUiTestsFoundation

protocol ScrollingHintsProvider {
    func scrollingHint(element: ElementSnapshot) -> ScrollingHint
}

final class ScrollingHintsProviderImpl: ScrollingHintsProvider {
    private let ipcClient: IpcClient
    
    init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    func scrollingHint(element: ElementSnapshot) -> ScrollingHint {
        guard let uniqueIdentifier = element.uniqueIdentifier.value else {
            return .internalError("Не удалось получить uniqueIdentifier")
        }
        
        let result = ipcClient.call(
            method: ScrollingHintIpcMethod(),
            arguments: uniqueIdentifier
        )
        
        switch result {
        case .data(let data):
            return data
        case .error:
            return .internalError("Не удалось получить scrollingHint")
        }
    }
}
