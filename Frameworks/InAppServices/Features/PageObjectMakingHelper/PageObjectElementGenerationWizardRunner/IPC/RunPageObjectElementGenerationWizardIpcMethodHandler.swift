#if MIXBOX_ENABLE_IN_APP_SERVICES

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
