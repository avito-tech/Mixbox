import MixboxTestsFoundation
import MixboxFoundation

extension ElementWithUi {
    // Uncomfortably disgusting solution. TODO: Better interface for getting values
    public func value<T>(
        file: StaticString = #filePath,
        line: UInt = #line,
        valueTitle: String,
        getValue: @escaping (ElementSnapshot) -> (T))
        -> T?
    {
        var valueOrNil: T?
        
        _ = core.filteringHiddenElement.interactionPerformer.perform(
            interaction: WrappedDescriptionElementInteraction(
                interaction: IsDisplayedAndMatchesCheck(
                    overridenPercentageOfVisibleArea: nil,
                    buildMatcher: { _ in
                        Matcher<ElementSnapshot>(
                            description: { "kludge to get a value" },
                            matchingFunction: { snapshot in
                                valueOrNil = getValue(snapshot)
                                
                                return .match
                            }
                        )
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
