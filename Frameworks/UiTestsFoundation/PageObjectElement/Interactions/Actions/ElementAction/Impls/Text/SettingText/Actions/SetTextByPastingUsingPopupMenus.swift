import MixboxFoundation

public final class SetTextByPastingUsingPopupMenus: ElementInteraction {
    private let text: String
    private let textEditingActionMode: TextEditingActionMode
    private let interactionCoordinates: InteractionCoordinates
    private let minimalPercentageOfVisibleArea: CGFloat
    
    public init(
        text: String,
        textEditingActionMode: TextEditingActionMode,
        interactionCoordinates: InteractionCoordinates,
        minimalPercentageOfVisibleArea: CGFloat)
    {
        self.text = text
        self.textEditingActionMode = textEditingActionMode
        self.interactionCoordinates = interactionCoordinates
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            text: text,
            textEditingActionMode: textEditingActionMode,
            interactionCoordinates: interactionCoordinates,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let text: String
        private let textEditingActionMode: TextEditingActionMode
        private let interactionCoordinates: InteractionCoordinates
        private let minimalPercentageOfVisibleArea: CGFloat
        
        public init(
            dependencies: ElementInteractionDependencies,
            text: String,
            textEditingActionMode: TextEditingActionMode,
            interactionCoordinates: InteractionCoordinates,
            minimalPercentageOfVisibleArea: CGFloat)
        {
            self.dependencies = dependencies
            self.text = text
            self.textEditingActionMode = textEditingActionMode
            self.interactionCoordinates = interactionCoordinates
            self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        }
        
        public func description() -> String {
            return """
                вставить текст "\(text)" из буфера обмена в "\(dependencies.elementInfo.elementName)" \
                через всплывающие меню на экране
                """
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        public func perform()
            -> InteractionResult
        {
            if !waitUntilMenuIsShown(timeout: 0) {
                let result = dependencies.interactionPerformer.perform(
                    interaction: OpenTextMenuAction(
                        interactionCoordinates: interactionCoordinates,
                        minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
                    )
                )
                
                if result.wasFailed {
                    return result
                }
            }
            
            dependencies.pasteboard.string = text
            
            // Ignore result. If waiting is faile, next actions will fail and provide proper result.
            _ = waitUntilMenuIsShown()
            
            switch textEditingActionMode {
            case .replace:
                return replace()
            case .append:
                return append()
            }
        }
        
        private func replace()
            -> InteractionResult
        {
            let result: InteractionResult = tapSelectAllButton()
            
            if result.wasFailed {
                return result
            } else {
                if text.isEmpty {
                    return dependencies.interactionPerformer.perform(
                        interaction: cutAction
                    )
                } else {
                    return dependencies.interactionPerformer.perform(
                        interaction: pasteAction
                    )
                }
            }
        }
        
        private func append()
            -> InteractionResult
        {
            if !text.isEmpty {
                let result = dependencies.interactionPerformer.perform(
                    interaction: pasteAction
                )
                
                if result.wasFailed {
                    return result
                }
            }
            
            return .success
        }
        
        private func tapSelectAllButton() -> InteractionResult {
            let selectAllMenuItem = dependencies.menuItemProvider.menuItem(possibleTitles: TextMenuTitles.selectAll)
            
            let thereIsSelectAllButton = selectAllMenuItem.waitForExistence(timeout: 0)
            if thereIsSelectAllButton {
                let result = dependencies.interactionPerformer.perform(
                    interaction: selectAllAction
                )
                
                return result
            } else {
                // If there is no text then there is no "Select All" button and that's okay.
                
                return .success
            }
        }
        
        private func waitUntilMenuIsShown(timeout: TimeInterval = 5) -> Bool {
            let anyMenuItem = dependencies.menuItemProvider.menuItem(
                possibleTitles: TextMenuTitles.selectAll + TextMenuTitles.paste + TextMenuTitles.cut
            )
            
            return anyMenuItem.waitForExistence(timeout: timeout)
        }
        
        private var selectAllAction: ElementInteraction {
            return TextMenuAction(possibleMenuTitles: TextMenuTitles.selectAll)
        }
        
        private var pasteAction: ElementInteraction {
            return TextMenuAction(possibleMenuTitles: TextMenuTitles.paste)
        }
        
        private var cutAction: ElementInteraction {
            return TextMenuAction(possibleMenuTitles: TextMenuTitles.cut)
        }
    }
}
