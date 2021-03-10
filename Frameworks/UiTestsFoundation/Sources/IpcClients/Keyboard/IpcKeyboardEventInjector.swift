import MixboxIpcCommon
import MixboxIpc
import MixboxFoundation

public final class IpcKeyboardEventInjector: KeyboardEventInjector {
    private let ipcClient: IpcClient
    
    public init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    public func inject(events: [KeyboardEvent], completion: @escaping (ErrorString?) -> ()) {
        ipcClient.call(
            method: InjectKeyboardEventsIpcMethod(),
            arguments: events,
            completion: { result in
                switch result {
                case .data(let data):
                    switch data {
                    case .returned:
                        completion(nil)
                    case .threw(let error):
                        completion(error)
                    }
                case .error(let error):
                    completion(
                        ErrorString(
                            """
                            Call to \(InjectKeyboardEventsIpcMethod.self) has failed with error: \(error)
                            """
                        )
                    )
                }
            }
        )
    }
}
