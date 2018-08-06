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
        
        return implementation.checks.isEnabled(checkSettings: checkSettings)
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
        
        return implementation.checks.isDisabled(checkSettings: checkSettings)
    }
}

public protocol ElementWithEnabledStateActions: class {
}
