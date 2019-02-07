public protocol AlmightyElementChecks {
    func isNotDisplayed(checkSettings: CheckSettings) -> Bool
    
    func isDisplayedAndMatches(
        checkSettings: CheckSettings,
        minimalPercentageOfVisibleArea: CGFloat,
        matcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
        -> Bool
    
    func with(settings: ElementSettings) -> AlmightyElementChecks
}
