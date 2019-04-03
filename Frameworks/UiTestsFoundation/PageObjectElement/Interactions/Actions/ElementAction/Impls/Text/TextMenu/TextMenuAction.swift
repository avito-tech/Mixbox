import MixboxFoundation

// NOTE: Not an "element" interaction actually. Should it be not ElementInteraction? What should it be?
//       NOTE: I wanted to rewrite working with text menus, e.g. to page objects or something
public final class TextMenuAction: ElementInteraction {
    private let possibleMenuTitles: [String]
    
    public init(
        possibleMenuTitles: [String])
    {
        self.possibleMenuTitles = possibleMenuTitles
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            possibleMenuTitles: possibleMenuTitles
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let possibleMenuTitles: [String]
        
        public init(
            dependencies: ElementInteractionDependencies,
            possibleMenuTitles: [String])
        {
            self.dependencies = dependencies
            self.possibleMenuTitles = possibleMenuTitles
        }
        
        public func description() -> String {
            let titlesDescription = possibleMenuTitlesDescription()
            
            return """
                тапнуть по высплывающему меню в возможными вариантами названий: \(titlesDescription)
                """
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        public func perform() -> InteractionResult {
            let selectAllButton = dependencies.menuItemProvider.menuItem(
                possibleTitles: possibleMenuTitles
            )
            
            guard selectAllButton.waitForExistence() else {
                let titlesDescription = possibleMenuTitlesDescription()
                
                return dependencies.interactionResultMaker.failure(
                    message: "Не удалось найти кнопку с одним из следующих вариантов названий: \(titlesDescription)"
                )
            }
            
            dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
            selectAllButton.tap()
            
            return .success
        }
        
        private func possibleMenuTitlesDescription() -> String {
            return possibleMenuTitles
                .map { "\"\($0)\"" }
                .joined(separator: " или ")
            
        }
    }
}
