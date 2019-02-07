public final class AlmightyElementImpl: AlmightyElement {
    public let settings: ElementSettings
    public let actions: AlmightyElementActions
    public let checks: AlmightyElementChecks
    public let asserts: AlmightyElementChecks
    
    public init(
        settings: ElementSettings,
        actions: AlmightyElementActions,
        checks: AlmightyElementChecks,
        asserts: AlmightyElementChecks)
    {
        self.settings = settings
        self.actions = actions
        self.checks = checks
        self.asserts = asserts
    }
    
    public func with(settings: ElementSettings) -> AlmightyElement {
        return AlmightyElementImpl(
            settings: settings,
            actions: actions.with(settings: settings),
            checks: checks.with(settings: settings),
            asserts: asserts.with(settings: settings)
        )
    }
    
    public func withAssertsInsteadOfChecks() -> AlmightyElement {
        return AlmightyElementImpl(
            settings: settings,
            actions: actions,
            checks: asserts,
            asserts: asserts
        )
    }
}
