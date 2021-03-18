// We have to patch podspecs, because we can't control validation of podspecs.
// In our tests we define MIXBOX_ENABLE_IN_APP_SERVICES in build settings,
// and nothing works without it (it is not a side effect of anything, it is
// a feature that protects user from having Mixbox in release builds).
// We can't do same with commands like `pod repo push` or `pod trunk push`.
// So the only way to work around failing validation is to disable it.
// And the bonus is that everything works faster (note that this is just a bonus),
// and we are ok with it, since we have better tests than what cocoapods does.
public protocol CocoapodsValidationPatcher {
    func setPodspecValidationEnabled(_ enabled: Bool) throws
}
