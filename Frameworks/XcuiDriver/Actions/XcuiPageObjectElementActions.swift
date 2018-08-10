import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest
import MixboxFoundation
import MixboxIpcClients

private let waitForExistenceTimeoutForMenuItems: TimeInterval = 3

// TODO: Split the class
final class XcuiPageObjectElementActions: AlmightyElementActions {
    private let elementSettings: ElementSettings
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let keyboardEventInjector: KeyboardEventInjector
    
    init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        elementVisibilityChecker: ElementVisibilityChecker,
        keyboardEventInjector: KeyboardEventInjector)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.elementVisibilityChecker = elementVisibilityChecker
        self.keyboardEventInjector = keyboardEventInjector
    }
    
    // MARK: - AlmightyElementActions
    
    func with(settings: ElementSettings) -> AlmightyElementActions {
        return XcuiPageObjectElementActions(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            elementVisibilityChecker: elementVisibilityChecker,
            keyboardEventInjector: keyboardEventInjector
        )
    }
    
    func tap(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            (element: XCUIElement, _: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = element.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.tap()
            
            return .success
        }
    }
    
    func press(
        duration: Double,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            (element: XCUIElement, _: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = element.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.press(forDuration: duration)
            
            return .success
        }
    }
    
    func setText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        // I am not sure that we should set UIPasteboard.general.string that often.
        UIPasteboard.general.string = text
        
        return perform(actionSettings: actionSettings) { [weak self]
            (element: XCUIElement, _: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else { return .failureWithMessage("self == nil") }
            
            let tappableWrapper = element.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )

            // Make element focused
            tappableWrapper.tap()
            
            // We should type anything. This makes XCUI wait until element gains focus.
            // We can do it manually by checking `hasFocus` property of snapshot, but... this also works:
            element.typeText(XCUIKeyboardKey.delete.rawValue)
            
            // Select all
            strongSelf.keyboardEventInjector.inject { press in press.command(press.a()) }
            
            // Delete (I think we should try to remove this step, it seems to be not necessary)
            element.typeText(XCUIKeyboardKey.delete.rawValue)
            
            if !text.isEmpty {
                UIPasteboard.general.string = text
                
                // Paste
                strongSelf.keyboardEventInjector.inject { press in press.command(press.v()) }
            }
            
            return .success
        }
    }
    
    func typeText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            (element: XCUIElement, _: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = element.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.tap()
            
            XCUIApplication().typeText(text)
            
            return .success
        }
    }
    
    func pasteText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            (element: XCUIElement, _: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = element.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            UIPasteboard.general.string = text
            
            tappableWrapper.tap()
            tappableWrapper.press(forDuration: 1)
            
            let pasteButton = XcuiPageObjectElementActions.menuItem(
                possibleTitles: ["Вставить", "Paste"]
            )
            
            if pasteButton.waitForExistence(timeout: 1) {
                // I don't think that it is necessary to set pasteboard again,
                // I don't think that pasteboard is shared between simulators and can be dirty.
                // But this can help and removing this require thorough research if it can break something
                // even with a small chance (if it reproduces rarely).
                UIPasteboard.general.string = text
                pasteButton.tap()
            } else {
                return .failureWithMessage("Не удалось найти кнопку 'Вставить'")
            }
            
            return .success
        }
    }
    
    func cutText(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            (element: XCUIElement, _: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = element.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.tap()
            tappableWrapper.press(forDuration: 1)
            
            let selectAllButton = XcuiPageObjectElementActions.menuItem(
                possibleTitles: ["Выбрать все"]
            )
            
            guard selectAllButton.waitForExistence(timeout: waitForExistenceTimeoutForMenuItems) else {
                return  .failureWithMessage("Не удалось найти кнопку 'Выбрать все'")
            }
            
            selectAllButton.tap()
            
            let cutButton = XcuiPageObjectElementActions.menuItem(
                possibleTitles: ["Вырезать"]
            )
            
            guard cutButton.waitForExistence(timeout: waitForExistenceTimeoutForMenuItems) else {
                return .failureWithMessage("Не удалось найти кнопку 'Вырезать'")
            }
            
            cutButton.tap()
            
            return .success
        }
    }
    
    func clearTextByTypingBackspaceMultipleTimes(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            (element: XCUIElement, snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = element.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.tap()
            
            let value = snapshot.visibleText(fallback: snapshot.originalAccessibilityValue)
            
            if !value.isEmpty {
                let deleteString: String = value.map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
                
                XCUIApplication().typeText(deleteString)
            }
            
            return .success
        }
    }
    
    func swipe(
        direction: SwipeDirection,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            (element: XCUIElement, _: ElementSnapshot) -> InteractionSpecificResult in
            
            element.swipeToDirection(direction)
            
            return .success
        }
    }
    
    // MARK: - Private
    
    private func perform(
        actionSettings: ActionSettings,
        action: @escaping (_ element: XCUIElement, _ snapshot: ElementSnapshot) -> InteractionSpecificResult)
    {
        let interaction = interactionFactory.actionInteraction(
            specificImplementation: InteractionSpecificImplementation(execute: action),
            settings: ResolvedInteractionSettings(
                interactionSettings: actionSettings,
                elementSettings: elementSettings
            ),
            // TODO: Configurable percentage of visible area + meaningful default value.
            // 0.53 is more than half, so we can tap center safely. Also one of our buttons in visible only by 53%
            // and it was ok, so we made a value according to some button in some app (seems legit).
            minimalPercentageOfVisibleArea: 0.53
        )
        
        let interactionPerformer = interactionPerformerFactory.performerForInteraction(
            shouldReportResultToObserver: true
        )
        
        _ = interactionPerformer.performInteraction(interaction: interaction)
    }
    
    private static func menuItem(possibleTitles: [String]) -> XCUIElement {
        let xcuiElementQuery = XCUIApplication().menuItems.matching(
            NSPredicate(
                block: { [possibleTitles] snapshot, _ -> Bool in
                    if let snapshot = snapshot as? XCElementSnapshot {
                        return possibleTitles.reduce(false) { result, element in
                            result || snapshot.label == element
                        }
                    } else {
                        return false
                    }
                }
            )
        )
        return xcuiElementQuery.firstMatch
    }
}

private protocol TappableWrapper {
    func tap()
    func press(forDuration duration: TimeInterval)
}

extension XCUIElement: TappableWrapper {}
extension XCUICoordinate: TappableWrapper {}

private extension XCUIElement {
    func tappableWrapper(normalizedCoordinate: CGPoint?, absoluteOffset: CGVector?) -> TappableWrapper {
        let normalizedCoordinate = normalizedCoordinate ?? CGPoint(x: 0.5, y: 0.5)
        
        let xcuiCoordinate = coordinate(
            withNormalizedOffset: CGVector(
                dx: normalizedCoordinate.x,
                dy: normalizedCoordinate.y
            )
        )
        
        if let absoluteOffset = absoluteOffset {
            return xcuiCoordinate.withOffset(absoluteOffset)
        } else {
            return xcuiCoordinate
        }
    }
    
    func swipeToDirection(_ direction: SwipeDirection) {
        switch direction {
        case .up:
            swipeUp()
        case .down:
            swipeDown()
        case .left:
            swipeLeft()
        case .right:
            swipeRight()
        }
    }
}
