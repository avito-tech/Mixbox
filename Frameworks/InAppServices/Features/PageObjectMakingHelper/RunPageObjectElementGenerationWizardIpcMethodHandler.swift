#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

final class RunPageObjectElementGenerationWizardIpcMethodHandler: IpcMethodHandler {
    let method = RunPageObjectElementGenerationWizardIpcMethod()
    
    private let applicationWindowsProvider: ApplicationWindowsProvider
    
    init(applicationWindowsProvider: ApplicationWindowsProvider) {
        self.applicationWindowsProvider = applicationWindowsProvider
    }
    
    func handle(
        arguments: RunPageObjectElementGenerationWizardIpcMethod.Arguments,
        completion: @escaping (RunPageObjectElementGenerationWizardIpcMethod.ReturnValue) -> ())
    {
        DispatchQueue.main.async {
            print("TBD")
            
            completion(.returned(IpcVoid()))
        }
    }
}

#endif
