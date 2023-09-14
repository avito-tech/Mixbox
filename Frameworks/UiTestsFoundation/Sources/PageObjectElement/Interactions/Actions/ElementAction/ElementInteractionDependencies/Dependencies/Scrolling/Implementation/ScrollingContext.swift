import XCTest
import MixboxIpcCommon

// It is actually a while-loop extracted into a class.
// It become not valid after first call of `scrollIfNeeded()`.
// swiftlint:disable:next type_body_length
final class ScrollingContext {
    private let maxScrollingAttempts = 100
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let minimalPercentageOfVisibleArea: CGFloat
    private let elementResolver: ElementResolver
    private let expectedIndexOfSnapshotInResolvedElementQuery: Int
    private let applicationFrameProvider: ApplicationFrameProvider
    private let eventGenerator: EventGenerator
    private let interactionCoordinates: InteractionCoordinates?
    private let useHundredPercentAccuracyInVisibilityCheckForTargetElement: Bool
    
    // MARK: - State
    private var status: ScrollingResult.Status?

    private var snapshot: ElementSnapshot
    private var resolvedElementQuery: ResolvedElementQuery
    
    private var scrollingAttempts = 0
    
    // To detect stucking of scrolling (inability to change the state of scroll view)
    private var lastReceivedDraggingInstructions = [DraggingInstruction]()
    private var lastUsedInstructionIndex: Int?
    // This stores views that are already visible, or if scroll to them was stucked.
    private var viewIdsToSkip = Set<String>()
    
    // TODO: Share with swipe direction. Including calculation of normalized offsets.
    private enum Direction {
        case up
        case down
        case left
        case right
    }
    
    init(
        snapshot: ElementSnapshot,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery,
        scrollingHintsProvider: ScrollingHintsProvider,
        elementVisibilityChecker: ElementVisibilityChecker,
        minimalPercentageOfVisibleArea: CGFloat,
        applicationFrameProvider: ApplicationFrameProvider,
        eventGenerator: EventGenerator,
        elementResolver: ElementResolver,
        interactionCoordinates: InteractionCoordinates?,
        useHundredPercentAccuracyInVisibilityCheckForTargetElement: Bool)
    {
        self.snapshot = snapshot
        self.expectedIndexOfSnapshotInResolvedElementQuery = expectedIndexOfSnapshotInResolvedElementQuery
        self.resolvedElementQuery = resolvedElementQuery
        self.scrollingHintsProvider = scrollingHintsProvider
        self.elementVisibilityChecker = elementVisibilityChecker
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        self.applicationFrameProvider = applicationFrameProvider
        self.eventGenerator = eventGenerator
        self.elementResolver = elementResolver
        self.interactionCoordinates = interactionCoordinates
        self.useHundredPercentAccuracyInVisibilityCheckForTargetElement = useHundredPercentAccuracyInVisibilityCheckForTargetElement
    }
    
    func scrollIfNeeded() -> ScrollingResult {
        while status == nil && scrollingAttempts < maxScrollingAttempts {
            do {
                try performScrollingOnce()
            } catch {
                status = .error("\(error)")
            }
        }
        
        let finalStatus: ScrollingResult.Status = status
            ?? .error("auto-scrolling exhausted \(scrollingAttempts) out of \(maxScrollingAttempts) attempts")
        
        return ScrollingResult(
            status: finalStatus,
            updatedSnapshot: snapshot,
            updatedResolvedElementQuery: resolvedElementQuery
        )
    }
    
    private func performScrollingOnce() throws {
        let scrollingResult = scrollingHintsProvider.scrollingHint(element: snapshot)
        
        switch scrollingResult {
        case .shouldScroll(let draggingInstructions):
            followDraggingInstructions(draggingInstructions)
        case .shouldReloadSnapshots:
            status = .scrolled
            
            do {
                try reloadSnapshots()
            } catch {
                status = .error("failed to get scrolling hint, can't figure out how to scroll to the element")
            }
        case .canNotProvideHintForCurrentRequest:
            // TODO: use fallback?
            status = .error("failed to get scrolling hint, can't figure out how to scroll to the element")
        case .hintsAreNotAvailableForCurrentElement:
            // Fallback:
            try scrollUsingInformationFromSnapshot(snapshot: snapshot)
        case .internalError(let message):
            status = .error("failed to get scrolling hint: \(message)")
        }
        
        scrollingAttempts += 1
    }
    
    // Fallback when scrolling hint can not be retrieved from application (e.g. third party application)
    private func scrollUsingInformationFromSnapshot(snapshot: ElementSnapshot) throws {
        let draggingInstructions: [DraggingInstruction]
        
        if snapshot.frameRelativeToScreen.mb_left > applicationFrameProvider.applicationFrame.mb_right {
            draggingInstructions = draggingInstructionsForScrolling(direction: .right)
        } else if snapshot.frameRelativeToScreen.mb_right < applicationFrameProvider.applicationFrame.mb_left {
            draggingInstructions = draggingInstructionsForScrolling(direction: .left)
        } else if snapshot.frameRelativeToScreen.mb_top > applicationFrameProvider.applicationFrame.mb_bottom {
            draggingInstructions = draggingInstructionsForScrolling(direction: .down)
        } else if snapshot.frameRelativeToScreen.mb_bottom < applicationFrameProvider.applicationFrame.mb_top {
            draggingInstructions = draggingInstructionsForScrolling(direction: .up)
        } else {
            draggingInstructions = []
            
            try reloadSnapshots()
        }
        
        followDraggingInstructions(draggingInstructions)
    }
    
    private func draggingInstructionsForScrolling(dx: CGFloat, dy: CGFloat) -> [DraggingInstruction] {
        let frame = applicationFrameProvider.applicationFrame
        
        let initialTouchPoint = CGPoint(
            x: frame.mb_center.x - 0.45 * frame.width * dx,
            y: frame.mb_center.y - 0.45 * frame.width * dy
        )
        
        let targetTouchPoint = CGPoint(
            x: frame.mb_center.x + 0.45 * frame.width * dx,
            y: frame.mb_center.y + 0.45 * frame.width * dy
        )
        
        let instruction = DraggingInstruction(
            initialTouchPoint: initialTouchPoint,
            targetTouchPoint: targetTouchPoint,
            targetTouchPointExceedingScreenBounds: targetTouchPoint,
            elementIntersectsWithScreen: false,
            elementUniqueIdentifier: "fake"
        )
        
        return [instruction]
    }
    
    private func draggingInstructionsForScrolling(direction: Direction) -> [DraggingInstruction] {
        switch direction {
        case .up:
            return draggingInstructionsForScrolling(dx: 0, dy: 1)
        case .down:
            return draggingInstructionsForScrolling(dx: 0, dy: -1)
        case .left:
            return draggingInstructionsForScrolling(dx: 1, dy: 0)
        case .right:
            return draggingInstructionsForScrolling(dx: -1, dy: 0)
        }
    }
    
    private func followDraggingInstructions(_ draggingInstructions: [DraggingInstruction]) {
        dropSavedInstructionsIfNeeded(
            newInstructions: draggingInstructions
        )
        
        if !draggingInstructions.isEmpty {
            let (instructionToUse, indexOfInstructionToUse, stuckedTouchesDescriptions) = self.instructionToUse(
                draggingInstructions: draggingInstructions
            )
            
            if let indexOfInstructionToUse = indexOfInstructionToUse, let instructionToUse = instructionToUse {
                do {
                    try useDraggingInstruction(instructionToUse)
                
                    lastUsedInstructionIndex = indexOfInstructionToUse
                
                    try reloadSnapshots()
                } catch {
                    status = .error(
                        "error occured during scrolling: \(error)"
                    )
                }
            } else {
                let joined = stuckedTouchesDescriptions.joined(separator: ", ")
                status = .error(
                    "scrolling stuck: nothing happened after scrolling (\(joined))"
                )
            }
        } else {
            status = .scrolled // TODO: is it correct?
        }
        
        lastReceivedDraggingInstructions = draggingInstructions
    }
    
    func dropSavedInstructionsIfNeeded(
        newInstructions: [DraggingInstruction])
    {
        if newInstructions != lastReceivedDraggingInstructions {
            lastReceivedDraggingInstructions = []
            lastUsedInstructionIndex = nil
        }
    }
    
    // WARNING: This function may interrupt main loop.
    // Also it is bloated and needs rewriting.
    // TODO: Rewrite
    func instructionToUse(
        draggingInstructions: [DraggingInstruction])
        // swiftlint:disable:next large_tuple
        -> (instructionToUse: DraggingInstruction?, indexOfInstructionToUse: Int?, stuckedTouchesDescriptions: [String])
    {
        var stuckedTouchesDescriptions = [String]()
        var indexOfInstructionToUse: Int?
        var instructionToUse: DraggingInstruction?
        
        for (index, instruction) in draggingInstructions.enumerated() {
            if isStuckedAtInstruction(index: index, instruction: instruction) {
                let pointA = instruction.initialTouchPoint
                let pointB = instruction.targetTouchPoint
                
                let stuckedTouchDescription = "from point \(pointA) to point \(pointB)"
                stuckedTouchesDescriptions.append(stuckedTouchDescription)
                
                if let elementUniqueIdentifier = instruction.elementUniqueIdentifier {
                    viewIdsToSkip.insert(elementUniqueIdentifier)
                }
                
                continue
            } else if let elementUniqueIdentifier = instruction.elementUniqueIdentifier, viewIdsToSkip.contains(elementUniqueIdentifier) {
                continue
            } else {
                if let elementUniqueIdentifier = instruction.elementUniqueIdentifier,
                    let targetElementIdentifier = snapshot.uniqueIdentifier.valueIfAvailable
                {
                    let isTargetElement = (elementUniqueIdentifier == targetElementIdentifier)
                    let minimalPercentageOfVisibleArea: CGFloat = 1
                    
                    let elementVisibilityCheckerResultOrNil = try? elementVisibilityChecker.checkVisibility(
                        elementUniqueIdentifier: elementUniqueIdentifier,
                        interactionCoordinates: isTargetElement ? interactionCoordinates : nil,
                        useHundredPercentAccuracy: isTargetElement
                            ? useHundredPercentAccuracyInVisibilityCheckForTargetElement
                            : false
                    )
                    
                    if let elementVisibilityCheckerResult = elementVisibilityCheckerResultOrNil {
                        let elementIsSufficientlyVisible = elementVisibilityCheckerResult.percentageOfVisibleArea >= minimalPercentageOfVisibleArea
                        
                        if elementIsSufficientlyVisible {
                            viewIdsToSkip.insert(elementUniqueIdentifier)
                            
                            if isTargetElement {
                                status = .alreadyVisible(elementVisibilityCheckerResult)
                                break
                            } else {
                                continue
                            }
                        } else {
                            // do nothing
                        }
                    } else {
                        // do nothing
                    }
                }
                
                instructionToUse = instruction
                indexOfInstructionToUse = index
                
                break
            }
        }
        
        return (instructionToUse, indexOfInstructionToUse, stuckedTouchesDescriptions)
    }
    
    private func isStuckedAtInstruction(
        index: Int,
        instruction: DraggingInstruction)
        -> Bool
    {
        guard let lastUsedInstructionIndex = lastUsedInstructionIndex else {
            return false
        }
        
        guard index <= lastUsedInstructionIndex else {
            return false
        }
        
        guard let usedInstruction = lastReceivedDraggingInstructions.mb_elementAtIndex(index) else {
            return false
        }
        
        return usedInstruction == instruction
    }
    
    private func useDraggingInstruction(_ draggingInstruction: DraggingInstruction) throws {
        try eventGenerator.pressAndDrag(
            from: draggingInstruction.initialTouchPoint,
            to: draggingInstruction.targetTouchPoint,
            durationOfInitialPress: 0,
            velocity: 500,
            cancelInertia: true
        )
    }
    
    private func reloadSnapshots() throws {
        resolvedElementQuery = try elementResolver.resolveElement()
        
        let index = expectedIndexOfSnapshotInResolvedElementQuery
        if let newSnapshot = resolvedElementQuery.matchingSnapshots.mb_elementAtIndex(index) {
            // everything is ok
            snapshot = newSnapshot
        } else {
            status = .elementWasLostAfterScroll
        }
    }
}
