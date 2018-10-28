#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

final class VeiwHierarchyIpcMethodHandler: IpcMethodHandler {
    let method = VeiwHierarchyIpcMethod()
    
    func handle(arguments: IpcVoid, completion: @escaping (ViewHierarchy) -> ()) {
        DispatchQueue.main.async {
            let viewHieherarchy = ViewHierarchyBuilder().buildViewHierarchy()
            completion(viewHieherarchy)
        }
    }
}

#endif
