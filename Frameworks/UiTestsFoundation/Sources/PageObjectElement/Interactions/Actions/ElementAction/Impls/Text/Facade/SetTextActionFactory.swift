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
                    .joined(separator: " and ")
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
                return "focus on element"
            } else {
                return "focus on element, while not waiting until focused,"
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
            return "type text '\(text)' into '\(elementName)' using physical keyboard"
        case .paste:
            return "paste text '\(text)' into '\(elementName)' using physical keyboard"
        case .pasteUsingPopupMenus:
            return "paste text '\(text)' into '\(elementName)' using popup menus"
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
