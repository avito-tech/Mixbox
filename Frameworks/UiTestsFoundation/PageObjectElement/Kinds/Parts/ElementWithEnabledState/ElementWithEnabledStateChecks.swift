import MixboxTestsFoundation

public protocol ElementWithEnabledStateChecks: class {}
public extension ElementWithEnabledStateChecks where Self: Element {
    @discardableResult
    func isEnabled(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "\"\(info.elementName)\" доступно для нажатия"
        }
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { element in
                element.isEnabled == true
            }
        )
    }
    
    @discardableResult
    func isDisabled(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "\"\(info.elementName)\" недоступно для нажатия"
        }
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { element in
                element.isEnabled == false
            }
        )
    }
}
