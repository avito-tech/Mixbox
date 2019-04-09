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
                
                // TODO: result.wasFailed - wrap result?
                if result.wasFailed {
                    return result
                }
            }
            
            dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
            dependencies.textTyper.type(text: text)
            
            return .success
        }
        
        private func clearText() -> InteractionResult {
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { [dependencies] _ in
                dependencies.snapshotResolver.resolve(minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea) { snapshot in
                    let value = snapshot.text(fallback: snapshot.accessibilityValue as? String) ?? ""
                    
                    if !value.isEmpty {
                        let deleteString: String = value
                            .map { _ in dependencies.textTyper.keys.delete }
                            .joined()
                        
                        dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
                        dependencies.textTyper.type(text: deleteString)
                    }
                    
                    return .success
                }
            }
        }
    }
}
