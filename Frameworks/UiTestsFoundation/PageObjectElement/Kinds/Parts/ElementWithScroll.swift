import MixboxTestsFoundation

// Use this in tests (without file & line):

public protocol ElementWithScrollChecks: class {}
public extension ElementWithScrollChecks where Self: Element {
    @discardableResult
    func isScrollable(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "\"\(info.elementName)\" не скроллится"
        }
        
        return implementation.checks.isScrollable(checkSettings: checkSettings)
    }
}

public protocol ElementWithScrollActions: class {}
