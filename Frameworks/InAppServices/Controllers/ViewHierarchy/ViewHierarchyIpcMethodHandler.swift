#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

final class ViewHierarchyIpcMethodHandler: IpcMethodHandler {
    let method = ViewHierarchyIpcMethod()
    
    private let viewHierarchyProvider: ViewHierarchyProvider
    
    init(
        viewHierarchyProvider: ViewHierarchyProvider)
    {
        self.viewHierarchyProvider = viewHierarchyProvider
    }
    
    func handle(arguments: IpcVoid, completion: @escaping (ViewHierarchy) -> ()) {
        DispatchQueue.main.async { [viewHierarchyProvider] in
            let viewHieherarchy = viewHierarchyProvider.viewHierarchy()
            completion(viewHieherarchy)
        }
    }
}

#endif
