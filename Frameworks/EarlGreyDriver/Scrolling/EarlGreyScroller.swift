import EarlGrey

protocol EarlGreyScroller: class {
    @discardableResult
    func scrollToVisibleElement(elementMatcher: GREYMatcher)
        -> EarlGreyScrollerResult
}

// Simplest implementation of autoscrolling to element.
// Doesn't scroll up. Probably will not work with pull-to-refresh and very custom scroll views.

final class EarlGreyScrollerImpl: EarlGreyScroller {
    @discardableResult
    func scrollToVisibleElement(elementMatcher: GREYMatcher)
        -> EarlGreyScrollerResult
    {
        let result: EarlGreyScrollerResult
        
        if scrollTo(elementMatcher: elementMatcher) {
            result = .elementFoundAfterScrolling
        } else {
            result = .elementNotFoundAfterScrolling
        }
        
        return result
    }
    
    // MARK: - Private
    
    // Iterates every scroll view, tries to scroll every scroll view, returns true if found element after scrolling
    private func scrollTo(elementMatcher: GREYMatcher)
        -> Bool
    {
        let isScrollViewMatcher = EarlGreyHelperMatchers.isScrollViewSuitableForAutoScrolling()
        var wasFound = false
        
        EarlGreyInteractionDisambiguation.iterateEveryElement(
            ambigousInteraction: {
                EarlGrey.interactionForVisibleElement(elementMatcher: isScrollViewMatcher)
            },
            forEach: { arguments in
                let scrollingResult = scrollTo(
                    elementMatcher: elementMatcher,
                    iterationArguments: arguments
                )
                
                assert(!wasFound, "Expected to exit cycle on previous iteration")
                
                let wasJustFound = elementWasFound(scrollingResult: scrollingResult)
                wasFound = wasJustFound
                
                return iterationResult(scrollingResult: scrollingResult)
            }
        )
        
        return wasFound
    }
    
    func elementWasFound(scrollingResult: EarlGreySingleScrollViewScrollingResult) -> Bool {
        switch scrollingResult {
        case .interactionIsDone(let result):
            switch result {
            case .success:
                return true
            case .indexOutOfBoundsError,
                 .elementNotFoundError,
                 .otherError:
                return false
            }
        case .foundElementAfterScrolling:
            return true
        case .shouldSkipThisScrollView:
            return false
        }
    }
    
    func iterationResult(
        scrollingResult: EarlGreySingleScrollViewScrollingResult)
        -> EarlGreyInteractionDisambiguation.IterationResult
    {
        switch scrollingResult {
        case .interactionIsDone(let interactionResult):
            return EarlGreyInteractionDisambiguation.IterationResult(interactionResult, stopAfterSuccess: true)
        case .foundElementAfterScrolling:
            return .shouldStop
        case .shouldSkipThisScrollView:
            return .shouldContinue
        }
    }
    
    // Handles iteration process for a single iteration, tries to scroll a single scroll view
    private func scrollTo(
        elementMatcher: GREYMatcher,
        iterationArguments: EarlGreyInteractionDisambiguation.IterationArguments)
        -> EarlGreySingleScrollViewScrollingResult
    {
        let scrollViewInteraction = iterationArguments.disambiguatedInteraction
        let underlyingScrollViewResult = scrollViewInteraction.underlyingElement()
        
        let result: EarlGreySingleScrollViewScrollingResult?
        var scrollView: UIScrollView?
        
        switch underlyingScrollViewResult {
        case .success(let underlyingElement):
            if let localScrollView = underlyingElement as? UIScrollView {
                scrollView = localScrollView
                
                // should scroll this scrollview
                result = nil
            } else {
                assertionFailure("scrollViewInteraction reflects element that isn't a UIScrollView."
                    + " Try to figure out what's going on")
                result = .shouldSkipThisScrollView
            }
        case .indexOutOfBoundsError,
             .elementNotFoundError,
             .otherError:
            result = .interactionIsDone(underlyingScrollViewResult.mapSuccess { _ in .success(scrollViewInteraction) })
        }
        
        if let result = result {
            return result
        } else if let scrollView = scrollView {
            let singleScrollViewScroller = EarlGreySingleScrollViewScroller(
                scrollView: scrollView,
                scrollViewInteraction: scrollViewInteraction
            )
                
            return singleScrollViewScroller.scrollTo(elementMatcher: elementMatcher)
        } else {
            assertionFailure("Unexpected case - either result or scrollView should be non-nil")
            return EarlGreySingleScrollViewScrollingResult.shouldSkipThisScrollView
        }
    }
}
