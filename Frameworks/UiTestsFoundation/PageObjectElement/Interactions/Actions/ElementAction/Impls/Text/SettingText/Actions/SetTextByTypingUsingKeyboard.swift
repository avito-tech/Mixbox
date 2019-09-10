import MixboxFoundation

public final class SetTextByTypingUsingKeyboard: ElementInteraction {
    private let text: String
    private let textEditingActionMode: TextEditingActionMode
    private let minimalPercentageOfVisibleArea: CGFloat
    
    public init(
        text: String,
        textEditingActionMode: TextEditingActionMode,
        minimalPercentageOfVisibleArea: CGFloat)
    {
        self.text = text
        self.textEditingActionMode = textEditingActionMode
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
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let text: String
        private let textEditingActionMode: TextEditingActionMode
        private let minimalPercentageOfVisibleArea: CGFloat
        
        public init(
            dependencies: ElementInteractionDependencies,
            text: String,
            textEditingActionMode: TextEditingActionMode,
            minimalPercentageOfVisibleArea: CGFloat)
        {
            self.dependencies = dependencies
            self.text = text
            self.textEditingActionMode = textEditingActionMode
            self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        }
        
        public func description() -> String {
            return """
                напечатать посимвольно текст "\(text)" в "\(dependencies.elementInfo.elementName)" \
                с помощью физической клавиатуры"
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
            
            dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
            
            return dependencies.interactionResultMaker.makeResultCatchingErrors {
                try dependencies.textTyper.type(text: text)
                
                return .success
            }
        }
        
        private func clearText() -> InteractionResult {
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { [dependencies] _ in
                dependencies.snapshotResolver.resolve(minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea) { snapshot in
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
