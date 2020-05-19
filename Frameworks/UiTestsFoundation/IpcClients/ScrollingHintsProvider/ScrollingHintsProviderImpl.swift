import MixboxIpcCommon
import MixboxIpc

public final class ScrollingHintsProviderImpl: ScrollingHintsProvider {
    private let ipcClient: SynchronousIpcClient
    
    public init(ipcClient: SynchronousIpcClient) {
        self.ipcClient = ipcClient
    }
    
    public func scrollingHint(element: ElementSnapshot) -> ScrollingHint {
        guard let uniqueIdentifier = element.uniqueIdentifier.valueIfAvailable else {
            return .hintsAreNotAvailableForCurrentElement // TODO: "unable to get uniqueIdentifier"?
        }
        
        let result = ipcClient.call(
            method: ScrollingHintIpcMethod(),
            arguments: uniqueIdentifier
        )
        
        switch result {
        case .data(let data):
            return data
        case .error(let error):
            // TODO: use hintsAreNotAvailableForCurrentElement?
            // Maybe we should add more cases to the enum.
            // Maybe we should add String describing reason.
            // Maybe we should merge hintsAreNotAvailableForCurrentElement with canNotProvideHintForCurrentRequest.
            // When we'll experience any bug, we should fix it.
            return .internalError("Не удалось получить scrollingHint: \(error)")
        }
    }
}
