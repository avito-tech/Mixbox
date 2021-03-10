#if MIXBOX_ENABLE_IN_APP_SERVICES

// Can be used to wait for some resource to become idle.
//
// It is used to wait until application becomes stable, e.g. if you tap moving buttons, you will miss the buttons.
//
public protocol IdlingResource {
    func isIdle() -> Bool
}

#endif
