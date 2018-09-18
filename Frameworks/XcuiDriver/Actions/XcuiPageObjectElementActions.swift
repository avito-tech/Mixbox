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
    private let pollingConfiguration: PollingConfiguration
    
    init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        elementVisibilityChecker: ElementVisibilityChecker,
        keyboardEventInjector: KeyboardEventInjector,
        pollingConfiguration: PollingConfiguration)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.elementVisibilityChecker = elementVisibilityChecker
        self.keyboardEventInjector = keyboardEventInjector
        self.pollingConfiguration = pollingConfiguration
    }
    
    // MARK: - AlmightyElementActions
    
    func with(settings: ElementSettings) -> AlmightyElementActions {
        return XcuiPageObjectElementActions(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            elementVisibilityChecker: elementVisibilityChecker,
            keyboardEventInjector: keyboardEventInjector,
            pollingConfiguration: pollingConfiguration
        )
    }
    
    func tap(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = snapshot.tappableWrapper(
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
            (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = snapshot.tappableWrapper(
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
        
        perform(actionSettings: actionSettings) { [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            guard let strongSelf = self else {
                return .failureWithMessage("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = snapshot.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            // Make element focused
            tappableWrapper.tap()
        
            strongSelf.waitUntilKeyboardFocusIsGained(
                actionSettings: actionSettings,
                snapshot: snapshot,
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            // Select all
            strongSelf.keyboardEventInjector.inject { press in press.command(press.a()) }
            
            if text.isEmpty {
                // TODO: Support different applications
                XCUIApplication().typeText(XCUIKeyboardKey.delete.rawValue)
            } else {
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
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                return .failureWithMessage("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = snapshot.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.tap()
            
            strongSelf.waitUntilKeyboardFocusIsGained(
                actionSettings: actionSettings,
                snapshot: snapshot,
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
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
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                return .failureWithMessage("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = snapshot.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            UIPasteboard.general.string = text
            
            tappableWrapper.tap()
            
            strongSelf.perform(actionSettings: actionSettings) {
                (snapshot: ElementSnapshot) -> InteractionSpecificResult in
                
                let tappableWrapper = snapshot.tappableWrapper(
                    normalizedCoordinate: normalizedCoordinate,
                    absoluteOffset: absoluteOffset
                )
                
                tappableWrapper.press(forDuration: 1)
                
                return .success
            }
            
            let pasteButton = XcuiPageObjectElementActions.menuItem(
                possibleTitles: ["Вставить", "Paste"]
            )
            
            if pasteButton.waitForExistence(timeout: 5) {
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
            (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = snapshot.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.tap()
            // TODO: Reload snapshots
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
            (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            let tappableWrapper = snapshot.tappableWrapper(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.tap()
            
            let value = snapshot.visibleText(fallback: snapshot.accessibilityValue as? String) ?? ""
            
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
            (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            snapshot.swipe(direction: direction)
            
            return .success
        }
    }
    
    // MARK: - Private
    
    private func perform(
        actionSettings: ActionSettings,
        action: @escaping (_ snapshot: ElementSnapshot) -> InteractionSpecificResult)
    {
        let interaction = interactionFactory.actionInteraction(
            specificImplementation: InteractionSpecificImplementation(execute: action),
            settings: ResolvedInteractionSettings(
                interactionSettings: actionSettings,
                elementSettings: elementSettings,
                pollingConfiguration: pollingConfiguration
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
        
        XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
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
    
    private func waitUntilKeyboardFocusIsGained(
        actionSettings: ActionSettings,
        snapshot: ElementSnapshot,
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        attempts: Int = 50,
        tapEveryNthAttempt: Int? = 10,
        timeout: TimeInterval = 5)
    {
        if attempts > 0 {
            let timeoutForOneAttempt = timeout / TimeInterval(attempts)
            
            var hasFocus = snapshot.hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus()
            
            for attempt in 0..<attempts {
                if !hasFocus {
                    XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
                    perform(actionSettings: actionSettings) { snapshot -> InteractionSpecificResult in
                        if let tapEveryNthAttempt = tapEveryNthAttempt, tapEveryNthAttempt > 0, attempt % tapEveryNthAttempt == 0 {
                            snapshot.tappableWrapper(normalizedCoordinate: normalizedCoordinate, absoluteOffset: absoluteOffset).tap()
                        }
                        hasFocus = snapshot.hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus()
                        
                        return .success
                    }
                    Thread.sleep(forTimeInterval: timeoutForOneAttempt)
                } else {
                    break
                }
            }
        } else {
            assertionFailure("attempts should be > 0")
        }
    }
}

private protocol Tappable {
    func tap()
    func press(forDuration: TimeInterval)
    func press(forDuration: TimeInterval, thenDragTo: XCUICoordinate)
}

extension XCUICoordinate: Tappable {
}

private extension ElementSnapshot {
    func tappableWrapper(normalizedCoordinate: CGPoint?, absoluteOffset: CGVector?) -> Tappable {
        var tapCoordinate = frameOnScreen.mb_center
        
        if let normalizedCoordinate = normalizedCoordinate {
            tapCoordinate.x += frameOnScreen.width * (normalizedCoordinate.x - 0.5)
            tapCoordinate.y += frameOnScreen.height * (normalizedCoordinate.y - 0.5)
        }
        
        if let absoluteOffset = absoluteOffset {
            tapCoordinate.x += absoluteOffset.dx
            tapCoordinate.y += absoluteOffset.dy
        }
        
        return XCUIApplication().tappableCoordinate(point: tapCoordinate)
    }
}
