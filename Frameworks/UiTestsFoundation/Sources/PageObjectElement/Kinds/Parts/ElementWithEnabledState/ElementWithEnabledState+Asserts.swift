import MixboxTestsFoundation

public extension ElementWithEnabledState {
    @discardableResult
    func assertIsEnabled(
        file: StaticString = #filePath,
        line: UInt = #line)
        -> Bool
    {
        return core.checkIsDisplayedAndMatches(
            buildMatcher: { element in element.isEnabled == true },
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" is enabled
                """
            },
            file: file,
            line: line
        )
    }
    
    @discardableResult
    func assertIsDisabled(
        file: StaticString = #filePath,
        line: UInt = #line)
        -> Bool
    {
        return core.checkIsDisplayedAndMatches(
            buildMatcher: { element in element.isEnabled == false },
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" is not enabled
                """
            },
            file: file,
            line: line
        )
    }
}
