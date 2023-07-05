import MixboxIpcCommon

public final class SetTextActionFactory {
    public enum ElementSelectionMethod {
        case selectElement(ensureElementGainsFocus: Bool)
        case doNotSelectElement
        
        public static var `default`: ElementSelectionMethod {
            .selectElement(ensureElementGainsFocus: true)
        }
    }
    
    public enum InputMethod {
        case type
        case paste // fastest
        case pasteUsingPopupMenus
        
        public static var `default`: InputMethod {
            .paste
        }
    }
    
    // MARK: - Public
    
    public static func setTextAction(
        text: String,
        elementSelectionMethod: ElementSelectionMethod,
        inputMethod: InputMethod,
        textEditingActionMode: TextEditingActionMode,
        interactionCoordinates: InteractionCoordinates)
        -> ElementInteraction
    {
        return SetTextAction(
            descriptionBuilder: HumanReadableInteractionDescriptionBuilderImpl { info in
                let focusingActionDescription = self.focusingActionDescription(
                    elementSelectionMethod: elementSelectionMethod
                )
                
                let settingTextActionDescription = self.settingTextActionDescription(
                    text: text,
                    elementName: info.elementName,
                    inputMethod: inputMethod
                )
                
                return [focusingActionDescription, settingTextActionDescription]
                    .compactMap { $0 }
                    .joined(separator: " и ")
            },
            focusingAction: focusingAction(
                interactionCoordinates: interactionCoordinates,
                elementSelectionMethod: elementSelectionMethod
            ),
            actionOnFocusedElement: actionOnFocusedElement(
                text: text,
                interactionCoordinates: interactionCoordinates,
                inputMethod: inputMethod,
                textEditingActionMode: textEditingActionMode
            )
        )
    }
    
    // MARK: - Private
    
    private static func focusingActionDescription(
        elementSelectionMethod: ElementSelectionMethod)
        -> String?
    {
        switch elementSelectionMethod {
        case .selectElement(let ensureElementGainsFocus):
            if ensureElementGainsFocus {
                return "сфокусироваться на элементе"
            } else {
                return "сфокусироваться на элементе, не ожидая фокусировки,"
            }
        case .doNotSelectElement:
            return nil
        }
    }
    
    private static func settingTextActionDescription(
        text: String,
        elementName: String,
        inputMethod: InputMethod)
        -> String?
    {
        switch inputMethod {
        case .type:
            return "напечатать текст '\(text)' в '\(elementName)' с помощью физической клавиатуры"
        case .paste:
            return "вставить текст '\(text)' в '\(elementName)' с помощью физической клавиатуры"
        case .pasteUsingPopupMenus:
            return "вставить текст '\(text)' в '\(elementName)' с помощью всплывающего меню"
        }
    }
    
    private static func focusingAction(
        interactionCoordinates: InteractionCoordinates,
        elementSelectionMethod: ElementSelectionMethod)
        -> ElementInteraction?
    {
        switch elementSelectionMethod {
        case .selectElement(let ensureElementGainsFocus):
            if ensureElementGainsFocus {
                return FocusKeyboardOnElementAction(
                    interactionCoordinates: interactionCoordinates
                )
            } else {
                return TapAction(
                    interactionCoordinates: interactionCoordinates
                )
            }
        case .doNotSelectElement:
            return nil
        }
    }
    
    private static func actionOnFocusedElement(
        text: String,
        interactionCoordinates: InteractionCoordinates,
        inputMethod: InputMethod,
        textEditingActionMode: TextEditingActionMode)
        -> ElementInteraction
    {
        switch inputMethod {
        case .type:
            return SetTextByTypingUsingKeyboard(
                text: text,
                textEditingActionMode: textEditingActionMode
            )
        case .paste:
            return SetTextByPastingUsingKeyboard(
                text: text,
                textEditingActionMode: textEditingActionMode
            )
        case .pasteUsingPopupMenus:
            return SetTextByPastingUsingPopupMenus(
                text: text,
                textEditingActionMode: textEditingActionMode,
                interactionCoordinates: interactionCoordinates
            )
        }
    }
}
