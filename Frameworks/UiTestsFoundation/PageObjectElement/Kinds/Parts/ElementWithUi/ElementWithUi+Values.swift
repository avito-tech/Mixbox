import MixboxTestsFoundation
import MixboxFoundation

extension ElementWithUi {
    // Uncomfortably disgusting solution. TODO: Better interface for getting values
    public func value<T>(
        file: StaticString = #file,
        line: UInt = #line,
        minimalPercentageOfVisibleArea: CGFloat = 0.2,
        valueTitle: String,
        getValue: @escaping (ElementSnapshot) -> (T))
        -> T?
    {
        var valueOrNil: T? = nil
        
        _ = implementation.filteringHiddenElement.interactionPerformer.perform(
            interaction: WrappedDescriptionElementInteraction(
                interaction: IsDisplayedAndMatchesCheck(
                    minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
                    buildMatcher: { _ in
                        Matcher<ElementSnapshot>(description: { "kludge to get a value" }) { snapshot in
                            valueOrNil = getValue(snapshot)
                            
                            return .match
                        }
                    }
                ),
                descriptionBuilder: { dependencies in
                    """
                    получить значение "\(valueTitle)" видимого элемента "\(dependencies.elementInfo.elementName)"
                    """
                }
            ),
            interactionPerformingSettings: InteractionPerformingSettings(
                failTest: true,
                fileLine: FileLine(
                    file: file,
                    line: line
                )
            )
        )
        
        return valueOrNil
    }
}

private extension PageObjectElement {
    // TODO: Remove copypasta
    var filteringHiddenElement: PageObjectElement {
        return with(
            settings: settings.with(
                matcher: settings.matcher && IsNotDefinitelyHiddenMatcher()
            )
        )
    }
}
