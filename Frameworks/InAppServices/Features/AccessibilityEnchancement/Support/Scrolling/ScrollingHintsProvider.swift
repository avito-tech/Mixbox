#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxIpcCommon
import MixboxUiKit

// TODO: Split to classes.
// swiftlint:disable file_length
final class ScrollingHintsProvider {
    // Suitable for programmatic scroll
    // Can be converted to DraggingInstruction (that is suitable for more black-box way of scrolling: via touches)
    private struct ScrollingInstruction {
        let scrollView: UIScrollView
        let targetRect: CGRect
        let targetViewUniqueIdentifier: String?
    }
    
    static let instance = ScrollingHintsProvider()
    
    private let keyboardFrameService = KeyboardFrameService()
    
    // Hardcoded toggle for programmatic scroll. Will be useful to debug tests faster.
    // Will be probably useful to run tests faster. With ability to toggle it depending on how honestly you
    // want to test the app at that time (e.g.: it can be switched on on PRs, but switched off when you
    // test your app before the release).
    private let scrollInsideAppProgrammatically = false
    
    // 1. We don't want to scroll for few pixels
    // 2. We can not scroll  for few pixels precisely.
    // So we want to ignore some precision and win at performance and amount of side-effects in tests.
    // (there might be multimple unnecerrary scrolls without any threshold for scrolling)
    private let offsetThresholdForUsefulHint: CGFloat = 15
    
    // A value for a heuristic for determining area suitable for scrolling.
    // Set to (0.5, 0.5) to start scrolling from the center of the view.
    // But it will not be enough if there is a need to swipe with distance that is greater than half of the screen:
    //
    // You scroll for          This is not enough        Your page
    // a little                for changing pages        goes back
    //  |         |                |         |            |         |
    //  |[<---   ]|[...    =>  [<--|   ] [...|    =>  --->|[       ]|[...
    //  |         |                |         |            |         |
    //
    // Ideally you want to start the gesture from the first touchable pixel to the last touchable pixel.
    // But it is hard to implement. E.g. imagine a scroll view that is overlapped by a tabbar below and a navbar above.
    // To move content up you should start gesture somewhere right above the tabbar, but not at tabbar.
    //
    // The constant is a good guess (but not a deterministic solution) of where the area for gestures might be located.
    // Note that this constant will be used for every view, not only for scrollview that is overlapped by some bar.
    //
    // Example:
    // The point of start is marked as "O", it is within a certain area.
    // The point of end can be everywhere, it doesn't cause any problems to place it at the edge of the screen
    // (if there is a need to scroll to the edge or below)
    //
    //            0.5            0.5            0.5            0.5
    //             v              v              v              v
    //        +---------+    +---------+    +---------+    +---------+ < 0.0
    //        |         |    |         |    |    ^    |    |         | < 0.1
    //        |         |    |         |    |    |    |    |         | < 0.2
    //        | ....... |    | ...O... |    | ...|... |    | ....... | < 0.3
    //        | ....... |    | ...|... |    | ...|... |    | ....... |
    //  0.5 > | ....... |    | ...|... |    | ...O... |    |<------O | < 0.5
    //        |         |    |    |    |    |         |    |         |
    //        |         |    |    |    |    |         |    |         |
    //        |         |    |    |    |    |         |    |         | < 0.2
    //        |         |    |    V    |    |         |    |         | < 0.1
    //        +---------+    +---------+    +---------+    +---------+ < 0.0
    private let touchableAreaNormalized = UIEdgeInsets(
        top: 0.3,
        left: 0.1,
        bottom: 0.3,
        right: 0.1
    )
    
    private init() {
    }
    
    func scrollingHint(forScrollingToView view: UIView) -> ScrollingHint {
        let scrollingInstructions = self.scrollingInstructions(forScrollingToView: view)
        
        return scrollingHint(fromScrollingInstructions: scrollingInstructions)
    }
    
    private func scrollingHint(
        fromScrollingInstructions scrollingInstructions: [ScrollingInstruction])
         -> ScrollingHint
    {
        if !scrollingInstructions.isEmpty {
            if scrollInsideAppProgrammatically {
                for instruction in scrollingInstructions {
                    performInstructionProgrammatically(instruction)
                }
                return .shouldReloadSnapshots
            } else {
                let hints = scrollingInstructions.flatMap(draggingInstructionsFromInstruction)
                return .shouldScroll(hints)
            }
        } else {
            return .canNotProvideHintForCurrentRequest
        }
    }
    
    private func scrollingInstructions(forScrollingToView viewToScrollTo: UIView) -> [ScrollingInstruction] {
        var scrollingInstructions = [ScrollingInstruction]()
        
        var viewToScrollTo = viewToScrollTo
        var pointer: UIView? = viewToScrollTo
        
        // Assume the hierarchy:
        //
        // Window -> A (parent scroll view) -> B (child scroll view) -> C
        //
        // The task: make C centered in window.
        //
        // size of         A
        // window     _____/
        //       \_  |     |
        //       |   |     |
        //       |   |  *  |               (* - where C should be)
        //       |_  |     |         B
        //           |__ __|________/
        //           |_<--_|__[C]___|
        //           |_____|
        //
        // - viewToScrollTo = C
        // - Scroll B until C is visible.
        //
        // window          A
        // is here    _____/
        //       \_  |     |
        //       |   |     |
        //       |   |  ^  |
        //       |_  |  |  |  B
        //     ______|_____|_/
        //    |______|_[C]_|_|
        //           |_____|
        //
        // - viewToScrollTo = B
        // - Scroll A until B is visible.
        //
        //                         A
        //                    _____/
        //                   |     |
        //  window           |     |
        //  is here          |     |
        //        \_         |     |  B
        //        |    ______|_____|_/
        //        |   |______|_[C]_|_|       (centered in window!)
        //        |_         |_____|
        //
        // - viewToScrollTo = A
        //
        // - End
        //
        // Note that actual gestures will go in reversed order (see below).
        
        while let viewFromPointer = pointer {
            if let cell = viewFromPointer as? UICollectionViewCell,
                let parentCollectionView = cell.mb_fakeCellInfo?.parentCollectionView
            {
                // Handle fake cell
                if parentCollectionView.xScrollIsPossible || parentCollectionView.yScrollIsPossible {
                    scrollingInstructions.append(
                        ScrollingInstruction(
                            scrollView: parentCollectionView,
                            targetRect: frame(ofView: viewToScrollTo, inView: parentCollectionView),
                            targetViewUniqueIdentifier: nil
                        )
                    )
                    
                    viewToScrollTo = parentCollectionView
                }
                
                // The fake cell has no parent, but it has a reference
                // to the collection view
                pointer = parentCollectionView
            } else {
                // Handle other views
                if let scrollView = viewFromPointer as? UIScrollView, viewToScrollTo != scrollView {
                    if scrollView.xScrollIsPossible || scrollView.yScrollIsPossible {
                        scrollingInstructions.append(
                            ScrollingInstruction(
                                scrollView: scrollView,
                                targetRect: frame(ofView: viewToScrollTo, inView: scrollView),
                                targetViewUniqueIdentifier: viewToScrollTo.uniqueIdentifier
                            )
                        )
                        
                        viewToScrollTo = scrollView
                    }
                }
                
                pointer = viewFromPointer.superview
            }
        }
        
        // Order before: subview => superview
        // After reverse: superview => subview
        // This is because we can't scroll views that are not on the screen (obviously).
        return Array(scrollingInstructions.reversed())
    }
    
    private func frame(ofView child: UIView, inView parent: UIView) -> CGRect {
        if child === parent {
            return child.bounds
        }
        
        guard let childSuperview = child.superview else {
            return child.frame
        }
        
        var pointer: UIView? = childSuperview
        var frame = child.frame
        
        while let viewFromPointer = pointer, pointer != parent {
            if let superview = viewFromPointer.superview {
                frame = superview.convert(frame, from: viewFromPointer)
                pointer = superview
            } else if let parentCollectionView = (viewFromPointer as? UICollectionViewCell)?.mb_fakeCellInfo?.parentCollectionView {
                // Naive, but sufficient implementation of convert(:from:) for current cases
                frame = CGRect(
                    x: frame.origin.x + viewFromPointer.frame.origin.x,
                    y: frame.origin.y + viewFromPointer.frame.origin.y,
                    width: frame.size.width,
                    height: frame.size.height
                )
                
                pointer = parentCollectionView
            } else {
                pointer = nil
            }
        }
        
        return frame
    }
    
    // Converts universal instruction (suitable for programmatic scroll)
    // to more specific instructions for scrolling via touches.
    // TODO: Fix swiftlint:disable:next function_body_length
    private func draggingInstructionsFromInstruction(_ instruction: ScrollingInstruction) -> [DraggingInstruction] {
        let scrollView = instruction.scrollView
        let targetRect = instruction.targetRect
        
        if let scrollViewSuperview = scrollView.superview {
            let visibleScrollViewFrameInWindow = scrollViewSuperview.convert(scrollView.frame, to: nil)
                .mb_shrinked(scrollView.contentInset)
                .mb_cutBottom(keyboardFrameService.nextKeyboardFrameInWindow)
            
            // Beginning of the touch lies within the visible frame of scrollview.
            let absoluteFrameFrom = visibleScrollViewFrameInWindow
            
            // Target frame. Usually not visible (but not always)
            let absoluteFrameTo = scrollView.convert(targetRect, to: nil)
            
            var elementIntersectsWithScreen = false
            
            if let intersection = visibleScrollViewFrameInWindow.mb_intersectionOrNil(absoluteFrameTo) {
                // Gives a hint that element is already intersecting the screen.
                // It is not enough for determining if the element is visible,
                // but it is useful for performing visibility check. It wouldn't be performed if element
                // doesn't intersect with the screen (so it is for optimization).
                //
                // Visiblity check is needed to stop scrolling as soon as is enough.
                //
                // Why tests can not make this calculation on their own? Because it requires reloading AX hierarchy.
                // And it is slow. And this specific hint doesn't add additional costs.
                elementIntersectsWithScreen = intersection.isAlmostSameAs(
                    other: absoluteFrameTo,
                    threshold: offsetThresholdForUsefulHint
                )
            }
            
            var initialTouchPoint = absoluteFrameFrom.mb_center
            let distanceBetweenFrames = absoluteFrameTo.mb_center - absoluteFrameFrom.mb_center
            
            // Gestures goes in the opposite direction. E.g. target frame is above, touches will go down.
            let distanceOfTouch = -distanceBetweenFrames
            
            let yScrollIsPossible = scrollView.yScrollIsPossible
            let xScrollIsPossible = scrollView.xScrollIsPossible
            
            if xScrollIsPossible {
                if distanceOfTouch.dx > 0 {
                    // Move finger from left to right.
                    // The initial point will be the leftmost in touchable area.
                    // So we will move finger farther.
                    //
                    //    v- touchable area      gesture has maximal length
                    // |  ......  |              |  ......  |
                    // |  ......  |              |  O------>|
                    // |  ......  |              |  ......  |
                    //
                    initialTouchPoint.x = absoluteFrameFrom.mb_left
                        + touchableAreaNormalized.left * absoluteFrameFrom.width
                } else {
                    initialTouchPoint.x = absoluteFrameFrom.mb_right
                        - touchableAreaNormalized.right * absoluteFrameFrom.width
                }
            }
            
            if yScrollIsPossible {
                if distanceOfTouch.dy > 0 {
                    // Moving from top to bottom. Initial point is at the top.
                    initialTouchPoint.y = absoluteFrameFrom.mb_top
                        + touchableAreaNormalized.top * absoluteFrameFrom.height
                } else {
                    initialTouchPoint.y = absoluteFrameFrom.mb_bottom
                        - touchableAreaNormalized.bottom * absoluteFrameFrom.height
                }
            }
            
            let targetTouchPointExceedingScreenBounds = initialTouchPoint + distanceOfTouch
            
            return draggingInstructionsBySplittingDragByAxis(
                initialTouchPoint: initialTouchPoint,
                targetTouchPointExceedingScreenBounds: targetTouchPointExceedingScreenBounds,
                elementIntersectsWithScreen: elementIntersectsWithScreen,
                elementUniqueIdentifier: instruction.targetViewUniqueIdentifier,
                xScrollIsPossible: xScrollIsPossible,
                yScrollIsPossible: yScrollIsPossible
            )
        } else {
            return []
        }
    }
    
    // Makes good looking scroll. For example, we want to center an element at the bottom of the vertical scrollview,
    // (element is inside nested horizontal scroll view).
    //
    //  Goal: X->Y       Naive and not working       Working and nice
    //                      implementation            implementation
    //   _____                  _____                  _____
    //  |     |                |     |                |     |
    //  |  Y  |                |  Y  |                |  Y  |
    //  |     |                |   \ |                |  ^  |
    //  |     |                |    \|                |  |  |
    //  |     |                |     \                |  |  |
    //  |     |                |     |\               |  |  |
    //  |     |                |     | \              |  |  |
    //  |_____|________        |_____|__\_____        |__|__|________
    //  |     |        |       |     |   \    |       |  |  |        |
    //  |     |    X   |       |     |    X   |       |  L--|----X   |
    //  |_____|________|       |_____|________|       |_____|________|
    //  |_____|                |_____|                |_____|
    //
    // Note that one of vertical/horizontal component is not used when it is not needed.
    //
    private func draggingInstructionsBySplittingDragByAxis(
        initialTouchPoint: CGPoint,
        targetTouchPointExceedingScreenBounds: CGPoint,
        elementIntersectsWithScreen: Bool,
        elementUniqueIdentifier: String?,
        xScrollIsPossible: Bool,
        yScrollIsPossible: Bool)
        -> [DraggingInstruction]
    {
        var xInstruction: DraggingInstruction?
        var yInstruction: DraggingInstruction?
        
        let dx = targetTouchPointExceedingScreenBounds.x - initialTouchPoint.x
        if abs(dx) > offsetThresholdForUsefulHint && xScrollIsPossible {
            xInstruction = draggingInstructionsByPoints(
                initialTouchPoint: initialTouchPoint,
                targetTouchPointExceedingScreenBounds: CGPoint(
                    x: targetTouchPointExceedingScreenBounds.x,
                    y: initialTouchPoint.y
                ),
                elementIntersectsWithScreen: elementIntersectsWithScreen,
                elementUniqueIdentifier: elementUniqueIdentifier
            )
        }
        
        let dy = targetTouchPointExceedingScreenBounds.y - initialTouchPoint.y
        if abs(dy) > offsetThresholdForUsefulHint && yScrollIsPossible {
            yInstruction = draggingInstructionsByPoints(
                initialTouchPoint: initialTouchPoint,
                targetTouchPointExceedingScreenBounds: CGPoint(
                    x: initialTouchPoint.x,
                    y: targetTouchPointExceedingScreenBounds.y
                ),
                elementIntersectsWithScreen: elementIntersectsWithScreen,
                elementUniqueIdentifier: elementUniqueIdentifier
            )
        }
        
        return [yInstruction, xInstruction].compactMap { $0 }
    }
    
    private func draggingInstructionsByPoints(
        initialTouchPoint: CGPoint,
        targetTouchPointExceedingScreenBounds: CGPoint,
        elementIntersectsWithScreen: Bool,
        elementUniqueIdentifier: String?)
        -> DraggingInstruction
    {
        let screenSize = UIScreen.main.bounds.size
        let targetTouchPoint = targetTouchPointExceedingScreenBounds.constrainedTo(size: screenSize)
        
        return DraggingInstruction(
            initialTouchPoint: initialTouchPoint,
            targetTouchPoint: targetTouchPoint,
            targetTouchPointExceedingScreenBounds: targetTouchPointExceedingScreenBounds,
            elementIntersectsWithScreen: elementIntersectsWithScreen,
            elementUniqueIdentifier: elementUniqueIdentifier
        )
    }
    
    private func performInstructionProgrammatically(_ instruction: ScrollingInstruction) {
        scrollRectToVisible(
            rect: instruction.targetRect,
            scrollView: instruction.scrollView
        )
    }
    
    private func scrollRectToVisible(
        rect sourceRect: CGRect,
        scrollView: UIScrollView)
    {
        var visibleScrollViewFrame = scrollView.frame
            .mb_shrinked(scrollView.contentInset)
        
        if let scrollViewSuperview = scrollView.superview {
            visibleScrollViewFrame = visibleScrollViewFrame
                .mb_cutBottom(keyboardFrameService.nextKeyboardFrameInView(scrollViewSuperview))
        }
        
        var rectToBeVisible: CGRect = CGRect(
            origin: .zero,
            size: visibleScrollViewFrame.size
        )
        rectToBeVisible.mb_centerX = sourceRect.mb_centerX
        rectToBeVisible.mb_centerY = sourceRect.mb_centerY
        
        let contentRect = CGRect(
            x: 0,
            y: 0,
            width: scrollView.contentSize.width,
            height: scrollView.contentSize.height
        )
        
        if let intersection = rectToBeVisible.mb_intersectionOrNil(contentRect) {
            scrollView.scrollRectToVisible(intersection, animated: false)
        } else {
            // Is not possible, because contentRect is a rect that contains the entire scroll view,
            // and it is incorrect to scroll beyound the area that is valid for the scrollview.
            assertionFailure("Ошибка в рассчетах фреймов. Фрейм для доскролла выходит за границы контента scroll view.")
            scrollView.scrollRectToVisible(sourceRect, animated: false)
        }
    }
}

private extension CGRect {
    func isAlmostSameAs(other: CGRect, threshold: CGFloat) -> Bool {
        let centerIsAlmostSame = mb_center.isAlmostSameAs(
            other: other.mb_center,
            threshold: threshold
        )
        let widthIsAlmostSame = abs(width - other.width) < threshold
        let heightIsAlmostSame = abs(height - other.height) < threshold
        
        return centerIsAlmostSame && widthIsAlmostSame && heightIsAlmostSame
    }
}

private extension CGPoint {
    func isAlmostSameAs(other: CGPoint, threshold: CGFloat) -> Bool {
        let xIsAlmostSame = abs(x - other.x) < threshold
        let yIsAlmostSame = abs(y - other.y) < threshold
        
        return xIsAlmostSame && yIsAlmostSame
    }
    
    func constrainedTo(size: CGSize) -> CGPoint {
        var constrainedPoint = self
        if constrainedPoint.x < 0 {
            constrainedPoint.x = 0
        }
        if constrainedPoint.y < 0 {
            constrainedPoint.y = 0
        }
        if constrainedPoint.x > size.width {
            constrainedPoint.x = size.width
        }
        if constrainedPoint.y > size.height {
            constrainedPoint.y = size.height
        }
        return constrainedPoint
    }
}

extension UIScrollView {
    fileprivate var xScrollIsPossible: Bool {
        let contentFrame = frame.mb_shrinked(effectiveInsets)
        if contentFrame.width == 0 {
            return false
        } else {
            return contentSize.width / contentFrame.width > 1
        }
    }
    
    fileprivate var yScrollIsPossible: Bool {
        let contentFrame = frame.mb_shrinked(effectiveInsets)
        if contentFrame.height == 0 {
            return false
        } else {
            return contentSize.height / contentFrame.height > 1
        }
    }
    
    private var effectiveInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }
}

#endif
