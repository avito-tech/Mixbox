import MixboxFoundation

public final class SetTextByTypingUsingKeyboard: ElementInteraction {
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
            return """
                type "\(text)" character by character into "\(dependencies.elementInfo.elementName)" \
                using physical keyboard"
                """
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        public func perform() -> InteractionResult {
            switch textEditingActionMode {
            case .append:
                break
            case .replace:
                let result = clearText()
                
                if result.wasFailed {
                    return result
                }
            }
            
            return dependencies.interactionResultMaker.makeResultCatchingErrors {
                dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
                try dependencies.textTyper.type(text: text)
                
                return .success
            }
        }
        
        private func clearText() -> InteractionResult {
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { [dependencies] _ in
                dependencies.interactionResultMaker.makeResultCatchingErrors {
                    try dependencies.snapshotResolver.resolve { snapshot in
                        let value = snapshot.text(fallback: snapshot.accessibilityValue as? String) ?? ""
                        
                        if value.isEmpty {
                            return .success
                        } else {
                            return dependencies.interactionResultMaker.makeResultCatchingErrors {
                                let textTyperInstruction: [TextTyperInstruction] = value
                                    .map { _ in .key(.delete) }
                                
                                dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
                                try dependencies.textTyper.type(instructions: textTyperInstruction)
                                
                                return  .success
                            }
                        }
                    }
                }
            }
        }
    }
}
