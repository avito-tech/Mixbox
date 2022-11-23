#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public protocol TextInputPreferencesController {
    func setAutocorrectionEnabled(_ value: Bool)
    func setPredictionEnabled(_ value: Bool)
    func setDidShowGestureKeyboardIntroduction(_ value: Bool)
    func setDidShowContinuousPathIntroduction(_ value: Bool)
    func synchronizePreferences()
}

#endif
