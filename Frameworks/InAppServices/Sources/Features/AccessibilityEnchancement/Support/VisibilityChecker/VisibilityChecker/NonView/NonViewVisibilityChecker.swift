#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxTestability

public protocol NonViewVisibilityChecker {
    func checkVisibility(element: TestabilityElement) throws -> NonViewVisibilityCheckerResult
}

#endif
