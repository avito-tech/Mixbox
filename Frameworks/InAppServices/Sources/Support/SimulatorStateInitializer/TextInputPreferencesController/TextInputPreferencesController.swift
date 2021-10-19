#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol TextInputPreferencesController {
    func setAutocorrectionEnabled(_ value: Bool)
    func setPredictionEnabled(_ value: Bool)
    func setDidShowGestureKeyboardIntroduction(_ value: Bool)
    func setDidShowContinuousPathIntroduction(_ value: Bool)
    func synchronizePreferences()
}

#endif
