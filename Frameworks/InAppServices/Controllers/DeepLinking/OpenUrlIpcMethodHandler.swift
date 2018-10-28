#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation
import MixboxIpc
import MixboxIpcCommon

final class OpenUrlIpcMethodHandler: IpcMethodHandler {
    let method = OpenUrlIpcMethod()
    
    func handle(arguments: String, completion: @escaping (IpcMethodCallingResult) -> ()) {
        let deepLinkUrl = arguments
        
        guard let url = URL(string: deepLinkUrl) else {
            completion(.failure("URL не валиден: \(deepLinkUrl)"))
            return
        }
            
        DispatchQueue.main.async {
            if UIApplication.shared.openURL(url) {
                completion(.success)
            } else {
                completion(.failure("Не удалось открыть диплинк '\(deepLinkUrl)', убедитесь в его валидности"))
            }
        }
    }
}

#endif
