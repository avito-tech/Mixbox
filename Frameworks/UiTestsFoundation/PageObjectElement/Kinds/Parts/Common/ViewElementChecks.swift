public protocol ViewElementChecks: class {}
extension ViewElementChecks where Self: Element {
    @discardableResult
    public func isDisplayed(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "отображается \"\(info.elementName)\""
        }
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { element in
                AlwaysTrueMatcher() // check for visibility is built in `isDisplayedAndMatches`
            }
        )
    }
    
    @discardableResult
    public func isNotDisplayed(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "не отображается \"\(info.elementName)\""
        }
        
        return implementation.checks.isNotDisplayed(checkSettings: checkSettings)
    }
    
    @discardableResult
    public func isInHierarchy(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "\"\(info.elementName)\" присутствует в иерархии"
        }
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.0, // might be not visible
            matcher: { element in
                AlwaysTrueMatcher() // check for existing in hierarchy is built in `isDisplayedAndMatches`
            }
        )
    }
    
    @discardableResult
    public func hasValue(
        _ value: String,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "в \"\(info.elementName)\" accessibility value = \(value)"
        }
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { element in
                element.value == value
            }
        )
    }
    
    @discardableResult
    public func matches(
        minimalPercentageOfVisibleArea: CGFloat = 0.2,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil,
        matcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "в '\(info.elementName)' \(matcher(ElementMatcherBuilder()).description)"
        }
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            matcher: matcher
        )
    }
    
    @discardableResult
    public func matchesReference(
        image: UIImage,
        comparator: SnapshotsComparator = PerPixelSnapshotsComparator(),
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return matches(matcher: { element in
            element.matchesReference(image: image, comparator: comparator)
        })
    }
    
    @discardableResult
    public func matchesReference(
        image: UIImage,
        comparatorSelection: SnapshotsComparators,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return matchesReference(image: image, comparator: comparatorSelection)
    }

    @discardableResult
    public func becomesTallerAfter(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil,
        action: @escaping () -> ())
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "увеличился \"\(info.elementName)\""
        }
        
        return checkPositiveHeightDifference(
            action: action,
            differenceCalculation: { initial, final in
                final - initial
            },
            negativeDifferenceFailureMessage: { difference in
                "ожидалось, что элемент увеличится в высоту, но он уменьшился на \(abs(difference))"
            },
            checkSettings: checkSettings
        )
    }
    
    @discardableResult
    public func becomesShorterAfter(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil,
        action: @escaping () -> ())
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "уменьшился \"\(info.elementName)\""
        }
        
        return checkPositiveHeightDifference(
            action: action,
            differenceCalculation: { initial, final in
                initial - final
            },
            negativeDifferenceFailureMessage: { difference in
                "ожидалось, что элемент уменьшится в высоту, но он увеличился на \(abs(difference))"
            },
            checkSettings: checkSettings
        )
    }
    
    // TODO: Universal way to match 2 element snapshots - before and after
    private func checkPositiveHeightDifference(
        action: @escaping () -> (),
        differenceCalculation: @escaping ((initial: CGFloat, final: CGFloat)) -> (CGFloat),
        negativeDifferenceFailureMessage: @escaping (CGFloat) -> (String),
        checkSettings: CheckSettings)
        -> Bool
    {
        var snapshotBefore: ElementSnapshot? = nil
        
        // Kind of a kludge. Actually gets value.
        _ = implementation.checks.isDisplayedAndMatches(checkSettings: checkSettings, minimalPercentageOfVisibleArea: 0.2) { _ in
            Matcher<ElementSnapshot>(description: { "kludge to get value" }) { snapshot in
                snapshotBefore = snapshot
                return .match
            }
        }
        
        action()
        
        return implementation.checks.isDisplayedAndMatches(checkSettings: checkSettings, minimalPercentageOfVisibleArea: 0.2) { element in
            Matcher<ElementSnapshot>(description: { "checkPositiveHeightDifference, main matcher" }) { snapshot in
                guard let snapshotBefore = snapshotBefore else {
                    return .exactMismatch(mismatchDescription: { "internal error: snapshotBefore == nil" })
                }
                
                let heightDifference = differenceCalculation(
                    (
                        initial: snapshotBefore.frameOnScreen.height,
                        final: snapshot.frameOnScreen.height
                    )
                )
                return heightDifference > 0
                    ? .match
                    : .exactMismatch(mismatchDescription: { negativeDifferenceFailureMessage(heightDifference) })
            }
        }
    }
}
