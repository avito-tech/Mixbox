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
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { element in
                element.visibleText == expectedText
            }
        )
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
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { element in
                element.visibleText.matches(regularExpression: regularExpression)
            }
        )
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
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { element in
                element.visibleText.contains(text)
            }
        )
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
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { _ in
                Matcher<ElementSnapshot>(description: { "проверка текста произвольной функцией" }) { snapshot in
                    let text = (snapshot.visibleText.value ?? "") ?? "" // TODO: better handling
                    
                    if checker(text) {
                        return .match
                    } else {
                        // TODO: Во всех клиентах функции сделать хорошее описание об ошибке (сейчас они возвращают Bool).
                        // Вообще в большинстве случаев сейчас идет просто сбор текста, иногда с проверкой.
                        // Возможно мы вообще это дропнем это после выделения ассертов из Page Object Element:
                        // See issue #1
                        return .exactMismatch {
                            "проверка произвольной функцией провалилась при актуальном тексте '\(text)'"
                        }
                    }
                }
            }
        )
    }
    
    @discardableResult
    func hasAccessibilityLabel(
        _ expectedLabel: String,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            expectedLabel.isEmpty
                ? "в \"\(info.elementName)\" нет accessibilityLabel"
                : "в \"\(info.elementName)\" accessibilityLabel равен \"\(expectedLabel)\""
        }
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { element in
                element.label == expectedLabel
            }
        )
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
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { element in
                element.label.contains(text)
            }
        )
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
        
        return implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { _ in
                Matcher<ElementSnapshot>(description: { "проверка accessibilityLabel произвольной функцией" }) { snapshot in
                    let actual = snapshot.accessibilityLabel
                    if checker(actual) {
                        return .match
                    } else {
                        // TODO: Во всех клиентах функции сделать хорошее описание об ошибке (сейчас они возвращают Bool).
                        // Вообще в большинстве случаев сейчас идет просто сбор текста, иногда с проверкой.
                        // Возможно мы вообще это дропнем это после выделения ассертов из Page Object Element:
                        // See issue #1
                        return .exactMismatch {
                            "проверка произвольной функцией провалилась при актуальном accessibilityLabel '\(actual)'"
                        }
                    }
                }
            }
        )
    }
    
    func visibleText(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> String
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "получение значения видимого элемента \"\(info.elementName)\""
        }
        
        var value: String? = nil
        
        _ = implementation.checks.isDisplayedAndMatches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: 0.2,
            matcher: { _ in
                Matcher<ElementSnapshot>(description: { "kludge to get a value" }) { snapshot in
                    let actualValue: String = ((snapshot.visibleText.value ?? "") ?? "") // TODO: better handling
                    value = actualValue
                    return .match
                }
            }
        )
        
        guard let text = value else {
            UnavoidableFailure.fail("Внутренняя ошибка, смотри код: \(#file):\(#line)")
        }
        
        return text
    }
}
