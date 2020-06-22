#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon
import Foundation
import UIKit

final class GetPasteboardStringIpcMethodHandler: IpcMethodHandler {
    let method = GetPasteboardStringIpcMethod()
    
    func handle(arguments: IpcVoid, completion: @escaping (String?) -> ()) {
        completion(UIPasteboard.general.string)
    }
}

#endif
