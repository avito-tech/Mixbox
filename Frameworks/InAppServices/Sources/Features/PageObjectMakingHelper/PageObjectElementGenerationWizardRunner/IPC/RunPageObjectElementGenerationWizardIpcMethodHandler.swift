#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxIpc
import MixboxIpcCommon

final class RunPageObjectElementGenerationWizardIpcMethodHandler: IpcMethodHandler {
    let method = RunPageObjectElementGenerationWizardIpcMethod()
    
    private let pageObjectElementGenerationWizardRunner: PageObjectElementGenerationWizardRunner
    
    init(pageObjectElementGenerationWizardRunner: PageObjectElementGenerationWizardRunner) {
        self.pageObjectElementGenerationWizardRunner = pageObjectElementGenerationWizardRunner
    }
    
    func handle(
        arguments: RunPageObjectElementGenerationWizardIpcMethod.Arguments,
        completion: @escaping (RunPageObjectElementGenerationWizardIpcMethod.ReturnValue) -> ())
    {
        DispatchQueue.main.async { [pageObjectElementGenerationWizardRunner] in
            pageObjectElementGenerationWizardRunner.run {
                switch $0 {
                case .success:
                    completion(.returned(IpcVoid()))
                case .failure(let error):
                    completion(.threw(error))
                }
            }
        }
    }
}

#endif
