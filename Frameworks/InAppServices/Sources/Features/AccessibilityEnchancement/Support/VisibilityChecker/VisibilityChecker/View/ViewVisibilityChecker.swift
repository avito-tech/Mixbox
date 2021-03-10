#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol ViewVisibilityChecker {
    func checkVisibility(arguments: ViewVisibilityCheckerArguments) throws -> ViewVisibilityCheckerResult
}

#endif
