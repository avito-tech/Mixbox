import MixboxFoundation
import MixboxTestsFoundation

extension ElementWithUi {
    public func isDisplayed(
        file: StaticString = #filePath,
        line: UInt = #line)
        -> Bool
    {
        return core.checkIsDisplayedAndMatches(
            matcher: AlwaysTrueMatcher(), // check for visibility is built in `IsDisplayedAndMatchesCheck`
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" is displayed
                """
            },
            failTest: false,
            file: file,
            line: line
        )
    }
    
    public func assertIsDisplayed(
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        _ = core.checkIsDisplayedAndMatches(
            matcher: AlwaysTrueMatcher(), // check for visibility is built in `IsDisplayedAndMatchesCheck`
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" is displayed
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertIsNotDisplayed(
        maximumAllowedPercentageOfVisibleArea: CGFloat,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        _ = core.interactionPerformer.perform(
            interaction: IsNotDisplayedCheck(
                maximumAllowedPercentageOfVisibleArea: maximumAllowedPercentageOfVisibleArea
            ),
            interactionPerformingSettings: InteractionPerformingSettings(
                failTest: true,
                fileLine: FileLine(
                    file: file,
                    line: line
                )
            )
        )
    }
    
    public func assertIsNotDisplayed(
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        _ = core.interactionPerformer.perform(
            interaction: IsNotDisplayedCheck(),
            interactionPerformingSettings: InteractionPerformingSettings(
                failTest: true,
                fileLine: FileLine(
                    file: file,
                    line: line
                )
            )
        )
    }
    
    public func assertIsInHierarchy(
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        _ = core.checkIsDisplayedAndMatches(
            matcher: AlwaysTrueMatcher(), // check for existing in hierarchy is built in `isDisplayedAndMatches`
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" is in hierarchy
                """
            },
            overridenPercentageOfVisibleArea: 0.0, // this check doesn't require visibility
            file: file,
            line: line
        )
    }
    
    public func assertHasAccessibilityValue(
        _ value: String,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        _ = core.checkIsDisplayedAndMatches(
            buildMatcher: { element in
                element.accessibilityValue == value
            },
            description: { dependencies in
                """
                accessibilityValue in "\(dependencies.elementInfo.elementName)" is equal to "\(value)"
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertMatches(
        file: StaticString = #filePath,
        line: UInt = #line,
        matcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
    {
        _ = core.checkIsDisplayedAndMatches(
            buildMatcher: matcher,
            description: { dependencies in
                """
                in "\(dependencies.elementInfo.elementName)" \(matcher(dependencies.elementMatcherBuilder).description)
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertMatchesReference(
        image: UIImage,
        comparator: SnapshotsComparator,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        let buildMatcher: (ElementMatcherBuilder) -> ElementMatcher = { element in
            element.matchesReference(image: image, comparator: comparator)
        }
        
        _ = core.checkIsDisplayedAndMatches(
            buildMatcher: buildMatcher,
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" matches reference image
                """
            },
            overridenPercentageOfVisibleArea: 1.0,
            file: file,
            line: line
        )
    }
    
    public func assertMatchesReference(
        image: UIImage,
        comparatorType: SnapshotsComparatorType,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        let buildMatcher: (ElementMatcherBuilder) -> ElementMatcher = { element in
            element.matchesReference(image: image, comparatorType: comparatorType)
        }
        
        _ = core.checkIsDisplayedAndMatches(
            buildMatcher: buildMatcher,
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" matches reference image
                """
            },
            overridenPercentageOfVisibleArea: 1.0,
            file: file,
            line: line
        )
    }

    public func assertBecomesTallerAfter(
        file: StaticString = #filePath,
        line: UInt = #line,
        action: @escaping () -> ())
    {
        _ = checkPositiveHeightDifference(
            action: action,
            differenceCalculation: { initial, final in
                final - initial
            },
            description: { dependencies in
                """
                height of "\(dependencies.elementInfo.elementName)" increased
                """
            },
            negativeDifferenceFailureMessage: { difference in
                "expected that height of element increases, but it decreased by \(abs(difference))"
            },
            file: file,
            line: line
        )
    }
    
    public func assertBecomesShorterAfter(
        file: StaticString = #filePath,
        line: UInt = #line,
        action: @escaping () -> ())
    {
        _ = checkPositiveHeightDifference(
            action: action,
            differenceCalculation: { initial, final in
                initial - final
            },
            description: { dependencies in
                """
                height of "\(dependencies.elementInfo.elementName)" decreased
                """
            },
            negativeDifferenceFailureMessage: { difference in
                "expected that height of element decreases, but it increased by \(abs(difference))"
            },
            file: file,
            line: line
        )
    }
    
    // TODO: Universal way to match 2 element snapshots - before and after
    private func checkPositiveHeightDifference(
        action: @escaping () -> (),
        differenceCalculation: @escaping ((initial: CGFloat, final: CGFloat)) -> (CGFloat),
        description: @escaping (ElementInteractionDependencies) -> (String),
        negativeDifferenceFailureMessage: @escaping (CGFloat) -> (String),
        file: StaticString,
        line: UInt)
        -> Bool
    {
        let heightBefore = value(valueTitle: "frameRelativeToScreen.height") { $0.frameRelativeToScreen.height }
        
        action()
        
        return core.checkIsDisplayedAndMatches(
            matcher: Matcher<ElementSnapshot>(
                description: { "checkPositiveHeightDifference, main matcher" },
                matchingFunction: { snapshot in
                    guard let heightBefore = heightBefore else {
                        return .exactMismatch(
                            mismatchDescription: { "failed to get value of height before interaction" },
                            attachments: { [] }
                        )
                    }
                    
                    let heightDifference = differenceCalculation(
                        (
                            initial: heightBefore,
                            final: snapshot.frameRelativeToScreen.height
                        )
                    )
                    return heightDifference > 0
                        ? .match
                        : .exactMismatch(
                            mismatchDescription: { negativeDifferenceFailureMessage(heightDifference) },
                            attachments: { [] }
                        )
                }
            ),
            description: description,
            file: file,
            line: line
        )
    }
}
