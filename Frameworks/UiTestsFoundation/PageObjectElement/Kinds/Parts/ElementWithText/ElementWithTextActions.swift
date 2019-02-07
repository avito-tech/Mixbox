import MixboxTestsFoundation

public protocol ElementWithTextActions: class {}
public extension ElementWithTextActions where Self: Element {
    // Делает так, что текст вводится в текстовое поле.
    // Не нужно делать предположений по способу достижения результата.
    func setText(
        _ text: String,
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        let actionSettings = ActionSettings(file: file, line: line, description: description) { info in
            text.isEmpty
                ? "Очистить текст '\(text)' в '\(info.elementName)'"
                : "Выставить текст '\(text)' в '\(info.elementName)'"
        }
        
        implementation.actions.setText(
            text: text,
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            actionSettings: actionSettings
        )
    }
    
    func clearText(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        setText(
            "",
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            file: file,
            line: line,
            description: description
        )
    }
}

// DEPRECATED (See issue #2)
public extension ElementWithTextActions where Self: Element {
    @available(*, deprecated, message: "Используйте setText")
    func replaceText(
        _ text: String,
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        clearText(
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            file: file,
            line: line,
            description: description
        )
        typeText(
            text,
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            file: file,
            line: line,
            description: description
        )
    }
    
    // TODO: Assert text is not empty
    // Or apply fix: execute `clearText` instead.
    // Hmm, it seems to be a good solution for parametrized tests for example.
    @available(*, deprecated, message: "Используйте setText")
    func typeText(
        _ text: String,
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        let actionSettings = ActionSettings(file: file, line: line, description: description) { info in
            "Ввести текст '\(text)' в '\(info.elementName)'"
        }
        
        implementation.actions.typeText(
            text: text,
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            actionSettings: actionSettings
        )
    }
    
    @available(*, deprecated, message: "Используйте setText")
    func pasteText(
        _ text: String,
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        let actionSettings = ActionSettings(file: file, line: line, description: description) { info in
            "Ввести текст '\(text)' в '\(info.elementName)'"
        }
        
        implementation.actions.pasteText(
            text: text,
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            actionSettings: actionSettings
        )
    }
    
    @available(*, deprecated, message: "Используйте clearText")
    func cutText(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        let actionSettings = ActionSettings(file: file, line: line, description: description) { info in
            "Вырезать текст в '\(info.elementName)'"
        }
        
        implementation.actions.cutText(
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            actionSettings: actionSettings
        )
    }
    
    @available(*, deprecated, message: "Используйте clearText")
    func clearTextByTypingBackspaceMultipleTimes(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        let actionSettings = ActionSettings(file: file, line: line, description: description) { info in
            "Очистить текст в '\(info.elementName)'"
        }
        
        implementation.actions.clearTextByTypingBackspaceMultipleTimes(
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            actionSettings: actionSettings
        )
    }
}
