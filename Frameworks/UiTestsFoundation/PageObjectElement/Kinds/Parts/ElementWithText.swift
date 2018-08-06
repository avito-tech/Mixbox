import MixboxTestsFoundation

public protocol ElementWithTextChecks: class {}
public extension ElementWithTextChecks where Self: Element {
    @discardableResult
    func hasText(
        _ expectedText: String,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            expectedText.isEmpty
                ? "в \"\(info.elementName)\" нет текста"
                : "в \"\(info.elementName)\" текст равен \"\(expectedText)\""
        }
        
        let checker = { (actualText: String) -> InteractionSpecificResult in
            if actualText == expectedText {
                return .success
            } else {
                return .failureWithMessage("текст ожидался '\(expectedText)', актуальный: '\(actualText)'")
            }
        }
        
        return implementation.checks.checkText(checker: checker, checkSettings: checkSettings)
    }

    @discardableResult
    func textMatches(
        _ regularExpression: String,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "в \"\(info.elementName)\" текст соответствует регулярке \"\(regularExpression)\""
        }

        let checker = { (actualText: String) -> InteractionSpecificResult in
            if actualText.range(of: regularExpression, options: .regularExpression) != nil {
                return .success
            } else {
                return .failureWithMessage("текст не прошел проверку регуляркой '\(regularExpression)', актуальный текст: '\(actualText)'")
            }
        }

        return implementation.checks.checkText(checker: checker, checkSettings: checkSettings)
    }
    
    @discardableResult
    func containsText(
        _ text: String,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "в \"\(info.elementName)\" содержится текст \"\(text)\""
        }
        
        let checker = { (elementText: String) -> InteractionSpecificResult in
            if elementText.contains(text) {
                return .success
            } else {
                return .failureWithMessage(
                    "ожидалось содержание '\(text)' в тексте элемента, который по факту равен '\(elementText)'"
                )
            }
        }
        
        return implementation.checks.checkText(checker: checker, checkSettings: checkSettings)
    }
    
    @discardableResult
    func checkText(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil,
        checker: @escaping (String) -> (Bool))
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "проверка текста в \(info.elementName) произвольной функцией"
        }
        
        let checkerWithNonobviousFailureDescription = { (text: String) -> InteractionSpecificResult in
            if checker(text) {
                return .success
            } else {
                // TODO: Во всех клиентах функции сделать хорошее описание об ошибке (сейчас они возвращают Bool).
                // Вообще в большинстве случаев сейчас идет просто сбор текста, иногда с проверкой.
                // Возможно мы вообще это дропнем это после выделения ассертов из Page Object Element:
                // See issue #1
                return .failureWithMessage(
                    "проверка произвольной функцией провалилась при актуальном тексте '\(text)'"
                )
            }
        }
        
        return implementation.checks.checkText(
            checker: checkerWithNonobviousFailureDescription,
            checkSettings: checkSettings
        )
    }
    
    @discardableResult
    func hasAccessibilityLabel(
        _ expectedText: String,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            expectedText.isEmpty
                ? "в \"\(info.elementName)\" нет accessibilityLabel"
                : "в \"\(info.elementName)\" accessibilityLabel равен \"\(expectedText)\""
        }
        
        let checker = { (actualText: String) -> InteractionSpecificResult in
            if actualText == expectedText {
                return .success
            } else {
                return .failureWithMessage("accessibilityLabel ожидался '\(expectedText)', актуальный: '\(actualText)'")
            }
        }
        
        return implementation.checks.checkAccessibilityLabel(checker: checker, checkSettings: checkSettings)
    }
    
    @discardableResult
    func accessibilityLabelContains(
        _ text: String,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "в \"\(info.elementName)\" содержится текст \"\(text)\""
        }
        
        let checker = { (elementText: String) -> InteractionSpecificResult in
            if elementText.contains(text) {
                return .success
            } else {
                return .failureWithMessage(
                    "ожидалось содержание '\(text)' в тексте элемента, который по факту равен '\(elementText)'"
                )
            }
        }
        
        return implementation.checks.checkAccessibilityLabel(checker: checker, checkSettings: checkSettings)
    }
    
    @discardableResult
    func checkAccessibilityLabel(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil,
        checker: @escaping (String) -> (Bool))
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "проверка accessibilityLabel в \(info.elementName) произвольной функцией"
        }
        
        let checkerWithNonobviousFailureDescription = { (text: String) -> InteractionSpecificResult in
            if checker(text) {
                return .success
            } else {
                // TODO: Во всех клиентах функции сделать хорошее описание об ошибке (сейчас они возвращают Bool).
                // Вообще в большинстве случаев сейчас идет просто сбор текста, иногда с проверкой.
                // Возможно мы вообще это дропнем это после выделения ассертов из Page Object Element:
                // See issue #1
                return .failureWithMessage(
                    "проверка произвольной функцией провалилась при актуальном accessibilityLabel '\(text)'"
                )
            }
        }
        
        return implementation.checks.checkAccessibilityLabel(
            checker: checkerWithNonobviousFailureDescription,
            checkSettings: checkSettings
        )
    }
}

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
