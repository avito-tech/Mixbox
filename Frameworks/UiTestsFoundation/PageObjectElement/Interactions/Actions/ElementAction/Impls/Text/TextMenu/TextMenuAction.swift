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
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { _ in
                let selectAllButton = dependencies.menuItemProvider.menuItem(
                    possibleTitles: possibleMenuTitles
                )
                
                return dependencies.interactionResultMaker.makeResultCatchingErrors {
                    try dependencies.applicationQuiescenceWaiter.waitForQuiescence {
                        try selectAllButton.waitForExistence()
                        
                        dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
                        try selectAllButton.tap()
                        
                        return .success
                    }
                }
            }
        }
        
        private func possibleMenuTitlesDescription() -> String {
            return possibleMenuTitles
                .map { "\"\($0)\"" }
                .joined(separator: " или ")
        }
    }
}
