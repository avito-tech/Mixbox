import EarlGrey

final class EarlGreyInteractionDisambiguation {
    final class IterationArguments {
        let disambiguatedInteraction: GREYInteraction
        
        init(
            disambiguatedInteraction: GREYInteraction)
        {
            self.disambiguatedInteraction = disambiguatedInteraction
        }
    }
    
    // Q: How to get it?
    // A: Get EarlGreyDisambiguatedInteractionResult first, then use init()
    //    See `performOnDisambiguatedInteraction`. It is the only way now to get proper IterationResult.
    //
    // Q: Why not just Bool named `shouldContinue`?
    // A: I hope this will help you to know about out of bounds error in EarlGrey and handle it.
    //
    // Q: Why do I care about this error? Can't it be determined automatically?
    // A: I didn't find an easy way to implement this or to make it more convenient.
    enum IterationResult {
        case shouldStop
        case shouldContinue
        
        init<T>(_ result: EarlGreyDisambiguatedInteractionResult<T>, stopAfterSuccess: Bool = false) {
            switch result {
            case .success:
                self = stopAfterSuccess ? .shouldStop : .shouldContinue
            case .elementNotFoundError, .indexOutOfBoundsError:
                self = .shouldStop
            case .otherError:
                self = .shouldContinue
            }
        }
    }
    
    static func iterateEveryElement(
        ambigousInteraction: () -> GREYInteraction,
        forEach: (IterationArguments) -> (IterationResult))
    {
        var shouldIterate = true
        var elementIndex: UInt = 0
        
        while shouldIterate {
            guard let disambiguatedInteraction = ambigousInteraction().atIndex(elementIndex) else {
                shouldIterate = false
                continue
            }
            
            let iterationArguments = IterationArguments(
                disambiguatedInteraction: disambiguatedInteraction
            )
            
            let result = forEach(iterationArguments)
            
            switch result {
            case .shouldStop:
                shouldIterate = false
            case .shouldContinue:
                elementIndex += 1
            }
        }
    }
}
