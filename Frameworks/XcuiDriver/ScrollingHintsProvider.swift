import MixboxIpcCommon
import MixboxIpcClients
import MixboxIpc

protocol ScrollingHintsProvider {
    func scrollingHint(element: ElementSnapshot) -> ScrollingHint
}

final class ScrollingHintsProviderImpl: ScrollingHintsProvider {
    private let ipcClient: IpcClient
    
    init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    func scrollingHint(element: ElementSnapshot) -> ScrollingHint {
        guard let enhancedAccessibilityValue = element.enhancedAccessibilityValue else {
            return .internalError("Не удалось получить улучшенное accessibilityValue")
        }
        
        let result = ipcClient.call(
            method: ScrollingHintIpcMethod(),
            arguments: enhancedAccessibilityValue.uniqueIdentifier
        )
        
        switch result {
        case .data(let data):
            return data
        case .error:
            return .internalError("Не удалось получить scrollingHint")
        }
    }
}
