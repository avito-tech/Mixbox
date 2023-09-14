import MixboxTestsFoundation

extension ElementWithText {
    public func assertHasText(
        _ expectedText: String,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        _ = core.checkIsDisplayedAndMatches(
            buildMatcher: { element in
                element.text == expectedText
            },
            description: { dependencies in
                expectedText.isEmpty
                    ? "text is empty inside \"\(dependencies.elementInfo.elementName)\""
                    : "text in \"\(dependencies.elementInfo.elementName)\" is equal to \"\(expectedText)\""
            },
            file: file,
            line: line
        )
    }
    
    public func assertTextMatches(
        _ regularExpression: String,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        _ = core.checkIsDisplayedAndMatches(
            buildMatcher: { element in
                element.text.matches(regularExpression: regularExpression)
            },
            description: { dependencies in
                """
                text in "\(dependencies.elementInfo.elementName)" matches regular expression "\(regularExpression)"
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertContainsText(
        _ text: String,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        _ = core.checkIsDisplayedAndMatches(
            buildMatcher: { element in
                element.text.contains(text)
            },
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" contains text "\(text)"
                """
            },
            file: file,
            line: line
        )
    }
    
    public func assertHasAccessibilityLabel(
        _ expectedLabel: String,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        _ = core.checkIsDisplayedAndMatches(
            buildMatcher: { element in
                element.accessibilityLabel == expectedLabel
            },
            description: { dependencies in
                expectedLabel.isEmpty
                    ? "accessibilityLabel is empty in \"\(dependencies.elementInfo.elementName)\" accessibilityLabel"
                    : "accessibilityLabel in \"\(dependencies.elementInfo.elementName)\" is equal to \"\(expectedLabel)\""
            },
            file: file,
            line: line
        )
    }
    
    public func assertAccessibilityLabelContains(
        _ text: String,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        _ = core.checkIsDisplayedAndMatches(
            buildMatcher: { element in
                element.accessibilityLabel.contains(text)
            },
            description: { dependencies in
                """
                accessibilityLabel in "\(dependencies.elementInfo.elementName)" contains text "\(text)"
                """
            },
            file: file,
            line: line
        )
    }
}
