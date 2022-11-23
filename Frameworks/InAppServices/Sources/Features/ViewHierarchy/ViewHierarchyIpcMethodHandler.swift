#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
