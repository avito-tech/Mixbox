import MixboxFoundation
import MixboxTestsFoundation

// Helpers for making facades
extension PageObjectElementCore {
    public func checkIsDisplayedAndMatches(
        buildMatcher: @escaping (ElementMatcherBuilder) -> ElementMatcher,
        description: @escaping (ElementInteractionDependencies) -> (String),
        overridenPercentageOfVisibleArea: CGFloat? = nil,
        failTest: Bool = true,
        file: StaticString,
        line: UInt)
        -> Bool
    {
        let result = filteringHiddenElement.interactionPerformer.perform(
            interaction: WrappedDescriptionElementInteraction(
                interaction: IsDisplayedAndMatchesCheck(
                    overridenPercentageOfVisibleArea: overridenPercentageOfVisibleArea,
                    buildMatcher: { element in
                        buildMatcher(element)
                    }
                ),
                descriptionBuilder: { args in
                    "check that \(description(args))"
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
        matcher: ElementMatcher,
        description: @escaping (ElementInteractionDependencies) -> (String),
        overridenPercentageOfVisibleArea: CGFloat? = nil,
        failTest: Bool = true,
        file: StaticString,
        line: UInt)
        -> Bool
    {
        return checkIsDisplayedAndMatches(
            buildMatcher: { _ in matcher },
            description: description,
            overridenPercentageOfVisibleArea: overridenPercentageOfVisibleArea,
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
    public var filteringHiddenElement: PageObjectElementCore {
        return with.matcher(settings.matcher && IsNotDefinitelyHiddenMatcher())
    }
}
