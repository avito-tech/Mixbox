#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol TextInputFramework {
    func sharedTextInputPreferencesController() throws -> TextInputPreferencesController
}

#endif
