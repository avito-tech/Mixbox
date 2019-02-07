import MixboxIpcCommon
import MixboxIpcClients
import MixboxIpc
import MixboxUiTestsFoundation

public protocol ScrollingHintsProvider {
    func scrollingHint(element: ElementSnapshot) -> ScrollingHint
}

public final class ScrollingHintsProviderImpl: ScrollingHintsProvider {
    private let ipcClient: IpcClient
    
    init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    public func scrollingHint(element: ElementSnapshot) -> ScrollingHint {
        guard let uniqueIdentifier = element.uniqueIdentifier.value else {
            return .hintsAreNotAvailableForCurrentElement // "Не удалось получить uniqueIdentifier"
        }
        
        let result = ipcClient.call(
            method: ScrollingHintIpcMethod(),
            arguments: uniqueIdentifier
        )
        
        switch result {
        case .data(let data):
            return data
        case .error:
            // TODO: use hintsAreNotAvailableForCurrentElement?
            // Maybe we should add more cases to the enum.
            // Maybe we should add String describing reason.
            // Maybe we should merge hintsAreNotAvailableForCurrentElement with canNotProvideHintForCurrentRequest.
            // When we'll experience any bug, we should fix it.
            return .internalError("Не удалось получить scrollingHint")
        }
    }
}
