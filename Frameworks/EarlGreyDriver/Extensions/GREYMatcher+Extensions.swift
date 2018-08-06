import EarlGrey

extension GREYMatcher {
    func byAddingMatcher(_ matcher: GREYMatcher) -> GREYMatcher {
        return grey_allOf(
            [
                self,
                matcher
            ]
        )
    }
    
    func byAddingSufficientlyVisibleMatcher() -> GREYMatcher {
        return byAddingMatcher(grey_sufficientlyVisible())
    }
}
