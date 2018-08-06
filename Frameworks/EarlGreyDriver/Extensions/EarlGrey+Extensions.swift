import EarlGrey

extension EarlGrey {
    static func interactionForVisibleElement(elementMatcher: GREYMatcher)
        -> GREYInteraction
    {
        // To avoid ambiguity in UICollectionView, select visible element.
        
        // Full output of EarlGrey for element with same matcher:
        
        //   |  |  |  |  |  |  |--<SomeCell:0x7f8a5031fc50; AX=N; AX.id='passwordInput'; AX.frame={{0, 156}, {414, 60}}; AX.activationPoint={207, 186}; AX.traits='UIAccessibilityTraitNone'; AX.focused='N'; frame={{0, 76}, {414, 60}}; opaque; hidden; alpha=1>
        //   |  |  |  |  |  |  |--<SomeCell:0x7f8a4d69fba0; AX=N; AX.id='passwordInput'; AX.frame={{0, 156}, {414, 60}}; AX.activationPoint={207, 186}; AX.traits='UIAccessibilityTraitNone'; AX.focused='N'; frame={{0, 76}, {414, 60}}; opaque; alpha=1>
        
        // See that first element is hidden, but second is not.
        
        // TODO Support 'notDisplayed()' check. It shouldn't select visible element.
        return select(elementWithMatcher: elementMatcher.byAddingSufficientlyVisibleMatcher())
    }
    
    static func interactionForElement(elementMatcher: GREYMatcher) 
        -> GREYInteraction
    {
        return select(elementWithMatcher: elementMatcher)
    }
}
