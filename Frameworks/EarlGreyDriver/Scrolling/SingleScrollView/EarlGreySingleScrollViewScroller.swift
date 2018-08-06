import EarlGrey

// Operates with a single scrollview
final class EarlGreySingleScrollViewScroller {
    private let scrollView: UIScrollView
    private let scrollViewInteraction: GREYInteraction
    
    init(
        scrollView: UIScrollView,
        scrollViewInteraction: GREYInteraction)
    {
        self.scrollView = scrollView
        self.scrollViewInteraction = scrollViewInteraction
    }
    
    func scrollTo(elementMatcher: GREYMatcher) -> EarlGreySingleScrollViewScrollingResult {
        let verticalScrollPosition = verticalScrollPositionOf(scrollView: scrollView)
        
        if let verticalScrollDirection = verticalScrollDirectionFor(verticalScrollPosition: verticalScrollPosition) {
            return scrollIfNeeded(
                scrollViewInteraction: scrollViewInteraction,
                scrollView: scrollView,
                toElementWithMatcher: elementMatcher,
                direction: verticalScrollDirection
            )
        } else {
            return EarlGreySingleScrollViewScrollingResult.shouldSkipThisScrollView
        }
    }
    
    // MARK: - Adjustables
    
    func pointsToScrollPerScrollingAttempt() -> CGFloat {
        // the exact value doesn't matter,
        // but when the final value was slightly more than scrollable area's height, tests were executing 3% slower,
        // than when value was slightly less than scrollable area.
        // 500: 454.161 seconds (on 568pt device; hardcoded 500)
        // 448: 442.060 seconds (on 568pt device; 568 - 120)
        let statusBarStuffAndThingsHeight: CGFloat = 120
        
        return UIScreen.main.bounds.height - statusBarStuffAndThingsHeight
    }
    
    func scrollingAttemptsCount() -> Int {
        return 100
    }
    
    // MARK: - Private
    
    private func verticalScrollPositionOf(scrollView: UIScrollView)
        -> VerticalScrollPosition
    {
        let verticalScrollPosition: VerticalScrollPosition
        
        if scrollView.isScrolledToTopOrBeyond && scrollView.isScrolledToBottomOrBeyond {
            verticalScrollPosition = .fullScreen
        } else if scrollView.isScrolledToTopOrBeyond {
            verticalScrollPosition = .top
        } else if scrollView.isScrolledToBottomOrBeyond {
            verticalScrollPosition = .bottom
        } else {
            verticalScrollPosition = .middle
        }
        
        return verticalScrollPosition
    }
    
    private func verticalScrollDirectionFor(verticalScrollPosition: VerticalScrollPosition)
        -> VerticalScrollDirection?
    {
        let verticalScrollDirection: VerticalScrollDirection?
        
        switch verticalScrollPosition {
        case .top:
            verticalScrollDirection = .toBottom
        case .middle:
            verticalScrollDirection = .toTopAndBottom
        case .bottom:
            verticalScrollDirection = .toTop
        case .fullScreen:
            verticalScrollDirection = nil
        }
        
        return verticalScrollDirection
    }
    
    private func scrollIfNeeded(
        scrollViewInteraction: GREYInteraction,
        scrollView: UIScrollView,
        toElementWithMatcher elementMatcher: GREYMatcher,
        direction: VerticalScrollDirection?)
        -> EarlGreySingleScrollViewScrollingResult
    {
        guard let direction = direction else {
            return EarlGreySingleScrollViewScrollingResult.shouldSkipThisScrollView
        }
        
        let result: EarlGreySingleScrollViewScrollingResult
        
        switch direction {
        case .toTop:
            result = scroll(
                scrollViewInteraction: scrollViewInteraction,
                scrollView: scrollView,
                toElementWithMatcher: elementMatcher,
                greyDirection: .up
            )
            
        case .toBottom:
            result = scroll(
                scrollViewInteraction: scrollViewInteraction,
                scrollView: scrollView,
                toElementWithMatcher: elementMatcher,
                greyDirection: .down
            )
            
        case .toTopAndBottom:
            let resultForTop = scroll(
                scrollViewInteraction: scrollViewInteraction,
                scrollView: scrollView,
                toElementWithMatcher: elementMatcher,
                greyDirection: .up
            )
            
            switch resultForTop {
            case .interactionIsDone(let interactionResult):
                switch interactionResult {
                case .otherError:
                    result = scroll(
                        scrollViewInteraction: scrollViewInteraction,
                        scrollView: scrollView,
                        toElementWithMatcher: elementMatcher,
                        greyDirection: .down
                    )
                default:
                    result = resultForTop
                }
            default:
                result = resultForTop
            }
        }
        
        return result
    }
    
    private func scroll(
        scrollViewInteraction: GREYInteraction,
        scrollView: UIScrollView,
        toElementWithMatcher elementMatcher: GREYMatcher,
        greyDirection: GREYDirection)
        -> EarlGreySingleScrollViewScrollingResult
    {
        var result: EarlGreySingleScrollViewScrollingResult?
        
        for _ in 0 ..< scrollingAttemptsCount() where result == nil {
            switch greyDirection {
            case .left, .right:
                assertionFailure("Scrolling to left/right is not implemented")
            case .up:
                if scrollView.isScrolledToTopOrBeyond {
                    result = .shouldSkipThisScrollView
                }
            case .down:
                if scrollView.isScrolledToBottomOrBeyond {
                    result = .shouldSkipThisScrollView
                }
            }
            
            let scrollingResult = scroll(
                scrollViewInteraction: scrollViewInteraction,
                greyDirection: greyDirection
            )
            
            switch scrollingResult {
            case .success:
                // scrolled ok
                break
            case .indexOutOfBoundsError,
                 .elementNotFoundError,
                 .otherError:
                result = .interactionIsDone(scrollingResult)
            }
            
            let interaction = EarlGrey.interactionForVisibleElement(
                elementMatcher: elementMatcher
            )
            
            if interaction.isSufficientlyVisible() {
                result = EarlGreySingleScrollViewScrollingResult.interactionIsDone(.success(interaction))
                break
            }
        }
        
        return result ?? EarlGreySingleScrollViewScrollingResult.shouldSkipThisScrollView
    }
    
    private func scroll(
        scrollViewInteraction: GREYInteraction,
        greyDirection: GREYDirection)
        -> EarlGreyDisambiguatedInteractionResult<GREYInteraction>
    {
        return scrollViewInteraction.performOnDisambiguatedInteraction(
            action: grey_scrollInDirection(
                greyDirection,
                pointsToScrollPerScrollingAttempt()
            )
        )
    }
}
