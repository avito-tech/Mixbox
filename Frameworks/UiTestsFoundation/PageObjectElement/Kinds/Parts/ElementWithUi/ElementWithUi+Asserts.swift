import MixboxFoundation

extension ElementWithUi {
    public func isDisplayed(
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            matcher: AlwaysTrueMatcher(), // check for visibility is built in `IsDisplayedAndMatchesCheck`
            description: { dependencies in
                """
                отображается "\(dependencies.elementInfo.elementName)"
                """
            },
            failTest: false,
            file: file,
            line: line
        )
    }
    
    public func assertIsDisplayed(
        file: StaticString = #file,
        line: UInt = #line)
    {
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            matcher: AlwaysTrueMatcher(), // check for visibility is built in `IsDisplayedAndMatchesCheck`
            description: { dependencies in
                """
                отображается "\(dependencies.elementInfo.elementName)"
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertIsNotDisplayed(
        file: StaticString = #file,
        line: UInt = #line)
    {
        _ = implementation.interactionPerformer.perform(
            interaction: IsNotDisplayedCheck(
                maximumAllowedPercentageOfVisibleArea: CGFloat.leastNonzeroMagnitude
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
    
    public func assertIsInHierarchy(
        file: StaticString = #file,
        line: UInt = #line)
    {
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.0, // might be not visible
            matcher: AlwaysTrueMatcher(), // check for existing in hierarchy is built in `isDisplayedAndMatches`
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" присутствует в иерархии
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertHasAccessibilityValue(
        _ value: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            buildMatcher: { element in
                element.accessibilityValue == value
            },
            description: { dependencies in
                """
                в "\(dependencies.elementInfo.elementName)" accessibility value = \(value)
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertMatches(
        minimalPercentageOfVisibleArea: CGFloat = 0.2,
        file: StaticString = #file,
        line: UInt = #line,
        matcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
    {
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            buildMatcher: matcher,
            description: { dependencies in
                """
                в "\(dependencies.elementInfo.elementName)" \(matcher(dependencies.elementMatcherBuilder).description)
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertMatchesReference(
        image: UIImage,
        comparator: SnapshotsComparator,
        file: StaticString = #file,
        line: UInt = #line)
    {
        let buildMatcher: (ElementMatcherBuilder) -> ElementMatcher = { element in
            element.matchesReference(image: image, comparator: comparator)
        }
        
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 1.0,
            buildMatcher: buildMatcher,
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" соответствует референсному изображению
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertMatchesReference(
        image: UIImage,
        comparatorType: SnapshotsComparatorType,
        file: StaticString = #file,
        line: UInt = #line)
    {
        let buildMatcher: (ElementMatcherBuilder) -> ElementMatcher = { element in
            element.matchesReference(image: image, comparatorType: comparatorType)
        }
        
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 1.0,
            buildMatcher: buildMatcher,
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" соответствует референсному изображению
                """
            },
            file: file,
            line: line
        )
    }

    public func assertBecomesTallerAfter(
        file: StaticString = #file,
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
                высота "\(dependencies.elementInfo.elementName)" увеличилась
                """
            },
            negativeDifferenceFailureMessage: { difference in
                "ожидалось, что элемент увеличится в высоту, но он уменьшился на \(abs(difference))"
            },
            file: file,
            line: line
        )
    }
    
    public func assertBecomesShorterAfter(
        file: StaticString = #file,
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
                высота "\(dependencies.elementInfo.elementName)" уменьшилась
                """
            },
            negativeDifferenceFailureMessage: { difference in
                "ожидалось, что элемент уменьшится в высоту, но он увеличился на \(abs(difference))"
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
        
        return implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            matcher: Matcher<ElementSnapshot>(
                description: { "checkPositiveHeightDifference, main matcher" },
                matchingFunction: { snapshot in
                    guard let heightBefore = heightBefore else {
                        return .exactMismatch(
                            mismatchDescription: { "не удалось получить значение высоты до действия" },
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
