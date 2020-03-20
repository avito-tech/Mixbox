import MixboxTestsFoundation

public extension ElementWithEnabledState {
    @discardableResult
    func assertIsEnabled(
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return core.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            buildMatcher: { element in element.isEnabled == true },
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" доступно для нажатия
                """
            },
            file: file,
            line: line
        )
    }
    
    @discardableResult
    func assertIsDisabled(
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return core.checkIsDisplayedAndMatches(
            minimalPercentageOfVisibleArea: 0.2,
            buildMatcher: { element in element.isEnabled == false },
            description: { dependencies in
                """
                "\(dependencies.elementInfo.elementName)" недоступно для нажатия
                """
            },
            file: file,
            line: line
        )
    }
}
