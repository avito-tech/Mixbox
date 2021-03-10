#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public protocol PageObjectElementGenerationWizardRunner {
    func run(completion: (Result<Void, ErrorString>) -> ())
}

#endif
