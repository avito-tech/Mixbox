import Foundation
import MixboxFoundation
import MixboxIpcCommon

public final class SetTextByPastingUsingPopupMenus: ElementInteraction {
    private let text: String
    private let textEditingActionMode: TextEditingActionMode
    private let interactionCoordinates: InteractionCoordinates
    
    public init(
        text: String,
        textEditingActionMode: TextEditingActionMode,
        interactionCoordinates: InteractionCoordinates)
    {
        self.text = text
        self.textEditingActionMode = textEditingActionMode
        self.interactionCoordinates = interactionCoordinates
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            text: text,
            textEditingActionMode: textEditingActionMode,
            interactionCoordinates: interactionCoordinates
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let text: String
        private let textEditingActionMode: TextEditingActionMode
        private let interactionCoordinates: InteractionCoordinates
        
        public init(
            dependencies: ElementInteractionDependencies,
            text: String,
            textEditingActionMode: TextEditingActionMode,
            interactionCoordinates: InteractionCoordinates)
        {
            self.dependencies = dependencies
            self.text = text
            self.textEditingActionMode = textEditingActionMode
            self.interactionCoordinates = interactionCoordinates
        }
        
        public func description() -> String {
            return """
                paste text "\(text)" from pasteboard into "\(dependencies.elementInfo.elementName)" \
                via popup menus
                """
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        public func perform()
            -> InteractionResult
        {
            return dependencies.interactionResultMaker.makeResultCatchingErrors {
                try dependencies.pasteboard.setString(text)
                
                if !waitUntilMenuIsShown(timeout: 0) {
                    let result = dependencies.interactionPerformer.perform(
                        interaction: OpenTextMenuAction(
                            interactionCoordinates: interactionCoordinates
                        )
                    )
                    
                    if result.wasFailed {
                        return result
                    }
                }
            
                // Ignore result. If waiting is faile, next actions will fail and provide proper result.
                _ = waitUntilMenuIsShown()
                
                switch textEditingActionMode {
                case .replace:
                    return replace()
                case .append:
                    return append()
                }
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
            
            do {
                try selectAllMenuItem.waitForExistence(timeout: 0)
            } catch {
                // If there is no text then there is no "Select All" button and that's okay.
                
                return .success
            }
                
            let result = dependencies.interactionPerformer.perform(
                interaction: selectAllAction
            )
            
            return result
        }
        
        private func waitUntilMenuIsShown(timeout: TimeInterval = 5) -> Bool {
            let anyMenuItem = dependencies.menuItemProvider.menuItem(
                possibleTitles: TextMenuTitles.selectAll + TextMenuTitles.paste + TextMenuTitles.cut
            )
            
            do {
                try anyMenuItem.waitForExistence(timeout: timeout)
                return true
            } catch {
                return false
            }
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
