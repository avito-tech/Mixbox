import EarlGrey

extension GREYInteraction {
    func performSafeAssertion(_ assertion: GREYMatcher) -> Bool {
        var error: NSError?
        
        assert(assertion, error: &error)
        
        let assertionPassed = (error == nil)
        
        return assertionPassed
    }
    
    // Note: this function is slow. It takes up to 0.5s to execute. Use with care!
    // Try to optimize your code in order to reduce usages of this function
    func isSufficientlyVisible() -> Bool  {
        return performSafeAssertion(EarlGreyMatchers.isDisplayed())
    }
}
