import MixboxTestsFoundation

public protocol ElementWithImageChecks: class {}
public extension ElementWithImageChecks where Self: Element {
    @discardableResult
    func hasImage(
        _ image: UIImage,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "\"\(info.elementName)\" содержит картинку"
        }
        
        return implementation.checks.hasImage(image, checkSettings: checkSettings)
    }
    
    @discardableResult
    func hasAnyImage(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "\"\(info.elementName)\" содержит любую картинку"
        }
        
        return implementation.checks.hasAnyImage(checkSettings: checkSettings)
    }
    
    @discardableResult
    func hasNoImage(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "\"\(info.elementName)\" не содержит картинку"
        }
        
        return implementation.checks.hasNoImage(checkSettings: checkSettings)
    }
}

public protocol ElementWithImageActions: class {}
