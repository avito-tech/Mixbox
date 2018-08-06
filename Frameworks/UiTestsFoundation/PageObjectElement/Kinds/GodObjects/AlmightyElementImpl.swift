public final class AlmightyElementImpl: AlmightyElement {
    public let settings: ElementSettings
    public let actions: AlmightyElementActions
    public let checks: AlmightyElementChecks
    public let asserts: AlmightyElementChecks
    public let utils: AlmightyElementUtils
    
    public init(
        settings: ElementSettings,
        actions: AlmightyElementActions,
        checks: AlmightyElementChecks,
        asserts: AlmightyElementChecks,
        utils: AlmightyElementUtils)
    {
        self.settings = settings
        self.actions = actions
        self.checks = checks
        self.asserts = asserts
        self.utils = utils
    }
    
    public func with(settings: ElementSettings) -> AlmightyElement {
        return AlmightyElementImpl(
            settings: settings,
            actions: actions.with(settings: settings),
            checks: checks.with(settings: settings),
            asserts: asserts.with(settings: settings),
            utils: utils.with(settings: settings)
        )
    }
    
    public func withAssertsInsteadOfChecks() -> AlmightyElement {
        return AlmightyElementImpl(
            settings: settings,
            actions: actions,
            checks: asserts,
            asserts: asserts,
            utils: utils
        )
    }
}
