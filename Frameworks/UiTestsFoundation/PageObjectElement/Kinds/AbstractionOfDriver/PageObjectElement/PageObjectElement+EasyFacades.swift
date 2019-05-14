import MixboxFoundation

// Helpers for making facades
extension PageObjectElement {
    public func checkIsDisplayedAndMatches(
        minimalPercentageOfVisibleArea: CGFloat,
        buildMatcher: @escaping (ElementMatcherBuilder) -> ElementMatcher,
        description: @escaping (ElementInteractionDependencies) -> (String),
        failTest: Bool = true,
        file: StaticString,
        line: UInt)
        -> Bool
    {
        let result = filteringHiddenElement.interactionPerformer.perform(
            interaction: WrappedDescriptionElementInteraction(
                interaction: IsDisplayedAndMatchesCheck(
                    minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
                    buildMatcher: { element in
                        buildMatcher(element)
                    }
                ),
                descriptionBuilder: { args in
                    "проверить, что \(description(args))"
                }
            ),
            interactionPerformingSettings: InteractionPerformingSettings(
                failTest: failTest,
                fileLine: FileLine(
                    file: file,
                    line: line
                )
            )
        )
        
        return result.wasSuccessful
    }
    
    public func checkIsDisplayedAndMatches(
        minimalPercentageOfVisibleArea: CGFloat,
        matcher: ElementMatcher,
        description: @escaping (ElementInteractionDependencies) -> (String),
        failTest: Bool = true,
        file: StaticString,
        line: UInt)
        -> Bool
    {
        return checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            buildMatcher: { _ in matcher },
            description: description,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func perform(
        action: ElementInteraction,
        failTest: Bool,
        file: StaticString,
        line: UInt)
        -> Bool
    {
        let result = filteringHiddenElement.interactionPerformer.perform(
            interaction: action,
            interactionPerformingSettings: InteractionPerformingSettings(
                failTest: failTest,
                fileLine: FileLine(
                    file: file,
                    line: line
                )
            )
        )
        
        return result.wasSuccessful
    }
    
    // TODO: Move to a better place. It is not for facades. It is a vital part of working with accessibility hierarchy.
    private var filteringHiddenElement: PageObjectElement {
        return with(
            settings: settings.with(
                matcher: settings.matcher && IsNotDefinitelyHiddenMatcher()
            )
        )
    }
}
