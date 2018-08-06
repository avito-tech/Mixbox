import MixboxUiTestsFoundation
import XCTest
import MixboxIpcCommon

// It is actually a while-loop extracted into a class.
// It become not valid after first call of `scrollIfNeeded()`.
final class ScrollingContext {
    private let maxScrollingAttempts = 100
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let minimalPercentageOfVisibleArea: CGFloat
    private let elementResolver: ElementResolver
    private let expectedIndexOfSnapshotInResolvedElementQuery: Int
    
    private var status: ScrollingResult.Status?

    private var snapshot: ElementSnapshot
    private var resolvedElementQuery: ResolvedElementQuery
    
    private var scrollingAttempts = 0
    
    // To detect stucking of scrolling (inability to change the state of scroll view)
    private var lastReceivedDraggingInstructions = [DraggingInstruction]()
    private var lastUsedInstructionIndex: Int?
    // This stores views that are already visible, or if scroll to them was stucked.
    private var viewIdsToSkip = Set<String>()
    
    init(
        snapshot: ElementSnapshot,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery,
        scrollingHintsProvider: ScrollingHintsProvider,
        elementVisibilityChecker: ElementVisibilityChecker,
        minimalPercentageOfVisibleArea: CGFloat,
        elementResolver: ElementResolver)
    {
        self.snapshot = snapshot
        self.expectedIndexOfSnapshotInResolvedElementQuery = expectedIndexOfSnapshotInResolvedElementQuery
        self.resolvedElementQuery = resolvedElementQuery
        self.scrollingHintsProvider = scrollingHintsProvider
        self.elementVisibilityChecker = elementVisibilityChecker
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        self.elementResolver = elementResolver
    }
    
    func scrollIfNeeded() -> ScrollingResult {
        while status == nil && scrollingAttempts < maxScrollingAttempts {
            performScrollingOnce()
        }
        
        let finalStatus: ScrollingResult.Status = status
            ?? .internalError("скролл израсходовал \(scrollingAttempts) из \(maxScrollingAttempts) попыток")
        
        return ScrollingResult(
            status: finalStatus,
            updatedSnapshot: snapshot,
            updatedResolvedElementQuery: resolvedElementQuery
        )
    }
    
    private func performScrollingOnce() {
        let scrollingResult = scrollingHintsProvider.scrollingHint(element: snapshot)
        
        switch scrollingResult {
        case .shouldScroll(let draggingInstructions):
            followDraggingInstructions(draggingInstructions)
        case .shouldReloadSnapshots:
            status = .scrolled
            reloadSnapshots()
        case .canNotProvideHint:
            // TODO: fallback?
            status = .internalError("ошибка получения подсказки по скроллу: ничего не вышло")
        case .internalError(let message):
            status = .internalError("ошибка получения подсказки по скроллу: \(message)")
        }
        
        scrollingAttempts += 1
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
                useDraggingInstruction(instructionToUse)
                
                lastUsedInstructionIndex = indexOfInstructionToUse
                
                reloadSnapshots()
            } else {
                let joined = stuckedTouchesDescriptions.joined(separator: ", ")
                status = .internalError(
                    "cкролл застрял, ничего не произошло после скролла (\(joined))"
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
    func instructionToUse(
        draggingInstructions: [DraggingInstruction])
        -> (instructionToUse: DraggingInstruction?, indexOfInstructionToUse: Int?, stuckedTouchesDescriptions: [String])
    {
        var stuckedTouchesDescriptions = [String]()
        var indexOfInstructionToUse: Int?
        var instructionToUse: DraggingInstruction?
        
        for (index, instruction) in draggingInstructions.enumerated() {
            if isStuckedAtInstruction(index: index, instruction: instruction) {
                let pointA = instruction.initialTouchPoint
                let pointB = instruction.targetTouchPoint
                
                let stuckedTouchDescription = "из точки \(pointA) в точку \(pointB)"
                stuckedTouchesDescriptions.append(stuckedTouchDescription)
                
                if let elementUniqueIdentifier = instruction.elementUniqueIdentifier {
                    viewIdsToSkip.insert(elementUniqueIdentifier)
                }
                
                continue
            } else if let elementUniqueIdentifier = instruction.elementUniqueIdentifier, viewIdsToSkip.contains(elementUniqueIdentifier) {
                continue
            } else {
                if let elementUniqueIdentifier = instruction.elementUniqueIdentifier,
                    let targetElementIdentifier = snapshot.enhancedAccessibilityValue?.uniqueIdentifier
                {
                    let isTargetElement = (elementUniqueIdentifier == targetElementIdentifier)
                    let currentElementMinimalPercentageOfVisibleArea = isTargetElement
                        ? minimalPercentageOfVisibleArea
                        : 1.0
                    
                    let percentageOfVisibleArea = elementVisibilityChecker.percentageOfVisibleArea(
                        elementUniqueIdentifier: elementUniqueIdentifier
                    )
                    
                    let elementIsSufficientlyVisible = percentageOfVisibleArea >= currentElementMinimalPercentageOfVisibleArea
                    
                    if elementIsSufficientlyVisible {
                        viewIdsToSkip.insert(elementUniqueIdentifier)
                        
                        if isTargetElement {
                            status = .alreadyVisible(percentageOfVisibleArea: percentageOfVisibleArea)
                            break
                        } else {
                            continue
                        }
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
    
    private func useDraggingInstruction(_ draggingInstruction: DraggingInstruction) {
        let coordinateFrom = XCUIApplication().tappableCoordinate(
            point: draggingInstruction.initialTouchPoint
        )
        let coordinateTo = XCUIApplication().tappableCoordinate(
            point: draggingInstruction.targetTouchPoint
        )
        
        coordinateFrom.press(forDuration: 0, thenDragTo: coordinateTo)
    }
    
    private func reloadSnapshots() {
        resolvedElementQuery = elementResolver.resolveElement()
        
        let index = expectedIndexOfSnapshotInResolvedElementQuery
        if let newSnapshot = resolvedElementQuery.matchingSnapshots.mb_elementAtIndex(index) {
            // everything is ok
            snapshot = newSnapshot
        } else {
            status = .elementWasLostAfterScroll
        }
    }
}
