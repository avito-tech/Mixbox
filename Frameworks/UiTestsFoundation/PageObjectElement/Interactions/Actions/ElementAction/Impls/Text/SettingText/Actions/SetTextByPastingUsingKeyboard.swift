public final class SetTextByPastingUsingKeyboard: ElementInteraction {
    private let text: String
    private let textEditingActionMode: TextEditingActionMode
    
    public init(
        text: String,
        textEditingActionMode: TextEditingActionMode)
    {
        self.text = text
        self.textEditingActionMode = textEditingActionMode
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            text: text,
            textEditingActionMode: textEditingActionMode
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let text: String
        private let textEditingActionMode: TextEditingActionMode
        
        public init(
            dependencies: ElementInteractionDependencies,
            text: String,
            textEditingActionMode: TextEditingActionMode)
        {
            self.dependencies = dependencies
            self.text = text
            self.textEditingActionMode = textEditingActionMode
        }
    
        public func description() -> String {
            let keyToReplaceSelection = text.isEmpty ? "Delete" : "⌘V"
            return """
                заменить текст элемента "\(dependencies.elementInfo.elementName)" на "\(text)" с помощью ⌘A + \(keyToReplaceSelection)
                """
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        public func perform() -> InteractionResult {
            dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
            
            switch textEditingActionMode {
            case .replace:
                selectAll()
                
                if text.isEmpty {
                    clear()
                } else {
                    paste(text: text)
                }
            case .append:
                if !text.isEmpty {
                    paste(text: text)
                }
            }
            
            return .success
        }
        
        // TODO: Reuse SelectAllTextUsingHardwareKeyboardAction?
        // Drawbacks: can be slower due to a lot of overhead such as taking screenshot of action.
        private func selectAll() {
            dependencies.keyboardEventInjector.inject { press in press.command(press.a()) }
        }
        
        private func paste(text: String) {
            dependencies.pasteboard.string = text
            
            dependencies.keyboardEventInjector.inject { press in press.command(press.v()) }
        }
        
        private func clear() {
            dependencies.keyboardEventInjector.inject { press in press.command(press.backspace()) }
        }
    }
}
