import MixboxTestsFoundation

extension ElementWithText {
    public func assertHasText(
        _ expectedText: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            buildMatcher: { element in
                element.text == expectedText
            },
            description: { dependencies in
                expectedText.isEmpty
                    ? "в \"\(dependencies.elementInfo.elementName)\" нет текста"
                    : "в \"\(dependencies.elementInfo.elementName)\" текст равен \"\(expectedText)\""
            },
            file: file,
            line: line
        )
    }
    
    public func assertTextMatches(
        _ regularExpression: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            buildMatcher: { element in
                element.text.matches(regularExpression: regularExpression)
            },
            description: { dependencies in
                """
                в "\(dependencies.elementInfo.elementName)" текст соответствует регулярке "\(regularExpression)"
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertContainsText(
        _ text: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            buildMatcher: { element in
                element.text.contains(text)
            },
            description: { dependencies in
                """
                в "\(dependencies.elementInfo.elementName)" содержится текст "\(text)"
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertHasAccessibilityLabel(
        _ expectedLabel: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            buildMatcher: { element in
                element.accessibilityLabel == expectedLabel
            },
            description: { dependencies in
                expectedLabel.isEmpty
                    ? "в \"\(dependencies.elementInfo.elementName)\" нет accessibilityLabel"
                    : "в \"\(dependencies.elementInfo.elementName)\" accessibilityLabel равен \"\(expectedLabel)\""
            },
            file: file,
            line: line
        )
    }
    
    public func assertAccessibilityLabelContains(
        _ text: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        _ = implementation.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            buildMatcher: { element in
                element.accessibilityLabel.contains(text)
            },
            description: { dependencies in
                """
                в "\(dependencies.elementInfo.elementName)" accessibilityLabel содержит "\(text)"
                """
            },
            file: file,
            line: line
        )
    }
}
