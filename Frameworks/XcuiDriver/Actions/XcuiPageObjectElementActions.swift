import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest
import MixboxFoundation
import MixboxIpcClients
import MixboxIpcCommon
import MixboxIpcClients
import MixboxIpc
import MixboxUiKit
import MixboxUiTestsFoundation
import XCTest

private let waitForExistenceTimeoutForMenuItems: TimeInterval = 3

// TODO: Split the class
final class XcuiPageObjectElementActions: AlmightyElementActions {
    private let elementSettings: ElementSettings
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let keyboardEventInjector: KeyboardEventInjector
    private let pollingConfiguration: PollingConfiguration
    private let applicationProvider: ApplicationProvider
    private let applicationCoordinatesProvider: ApplicationCoordinatesProvider
    private let eventGenerator: EventGenerator
    
    init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        elementVisibilityChecker: ElementVisibilityChecker,
        keyboardEventInjector: KeyboardEventInjector,
        pollingConfiguration: PollingConfiguration,
        applicationProvider: ApplicationProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider,
        eventGenerator: EventGenerator)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.elementVisibilityChecker = elementVisibilityChecker
        self.keyboardEventInjector = keyboardEventInjector
        self.pollingConfiguration = pollingConfiguration
        self.applicationProvider = applicationProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
        self.eventGenerator = eventGenerator
    }
    
    // MARK: - AlmightyElementActions
    
    func with(settings: ElementSettings) -> AlmightyElementActions {
        return XcuiPageObjectElementActions(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            elementVisibilityChecker: elementVisibilityChecker,
            keyboardEventInjector: keyboardEventInjector,
            pollingConfiguration: pollingConfiguration,
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: applicationCoordinatesProvider,
            eventGenerator: eventGenerator
        )
    }
    
    func tap(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                throw ErrorString("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = try strongSelf.tappableWrapper(
                elementSnapshot: snapshot,
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
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                throw ErrorString("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = try strongSelf.tappableWrapper(
                elementSnapshot: snapshot,
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
        
        perform(actionSettings: actionSettings) {
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                throw ErrorString("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = try strongSelf.tappableWrapper(
                elementSnapshot: snapshot,
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
                strongSelf.applicationProvider.application.typeText(XCUIKeyboardKey.delete.rawValue)
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
                throw ErrorString("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = try strongSelf.tappableWrapper(
                elementSnapshot: snapshot,
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
            
            strongSelf.applicationProvider.application.typeText(text)
            
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
                throw ErrorString("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = try strongSelf.tappableWrapper(
                elementSnapshot: snapshot,
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            UIPasteboard.general.string = text
            
            tappableWrapper.tap()
            
            strongSelf.perform(actionSettings: actionSettings) {
                (snapshot: ElementSnapshot) -> InteractionSpecificResult in
                
                let tappableWrapper = try strongSelf.tappableWrapper(
                    elementSnapshot: snapshot,
                    normalizedCoordinate: normalizedCoordinate,
                    absoluteOffset: absoluteOffset
                )
                
                tappableWrapper.press(forDuration: 1)
                
                return .success
            }
            
            let pasteButton = strongSelf.menuItem(
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
                throw ErrorString("Не удалось найти кнопку 'Вставить'")
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
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                throw ErrorString("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = try strongSelf.tappableWrapper(
                elementSnapshot: snapshot,
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.tap()
            // TODO: Reload snapshots
            tappableWrapper.press(forDuration: 1)
            
            let selectAllButton = strongSelf.menuItem(
                possibleTitles: ["Выбрать все"]
            )
            
            guard selectAllButton.waitForExistence(timeout: waitForExistenceTimeoutForMenuItems) else {
                throw ErrorString("Не удалось найти кнопку 'Выбрать все'")
            }
            
            selectAllButton.tap()
            
            let cutButton = strongSelf.menuItem(
                possibleTitles: ["Вырезать"]
            )
            
            guard cutButton.waitForExistence(timeout: waitForExistenceTimeoutForMenuItems) else {
                throw ErrorString("Не удалось найти кнопку 'Вырезать'")
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
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                throw ErrorString("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let tappableWrapper = try strongSelf.tappableWrapper(
                elementSnapshot: snapshot,
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
            
            tappableWrapper.tap()
            
            let value = snapshot.visibleText(fallback: snapshot.accessibilityValue as? String) ?? ""
            
            if !value.isEmpty {
                let deleteString: String = value.map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
                
                strongSelf.applicationProvider.application.typeText(deleteString)
            }
            
            return .success
        }
    }
    
    func swipe(
        direction: SwipeDirection,
        actionSettings: ActionSettings)
    {
        return perform(actionSettings: actionSettings) {
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                throw ErrorString("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let swipeLength: CGFloat = 100
            let delta = snapshot.normalizedOffsetForSwipe(direction: direction) * swipeLength
            let origin = snapshot.frameOnScreen.mb_center
            
            strongSelf.eventGenerator.swipe(from: origin, to: origin + delta)
            
            return .success
        }
    }
    
    // MARK: - Private
    
    private func perform(
        actionSettings: ActionSettings,
        action: @escaping (_ snapshot: ElementSnapshot) throws -> InteractionSpecificResult)
    {
        let interaction = interactionFactory.actionInteraction(
            specificImplementation: InteractionSpecificImplementation {
                do {
                    return try action($0)
                } catch let error {
                    return .failureWithMessage("\(error)")
                }
            },
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
    
    private func menuItem(possibleTitles: [String]) -> XCUIElement {
        let xcuiElementQuery = applicationProvider.application.menuItems.matching(
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
                    perform(actionSettings: actionSettings) {
                        [weak self] snapshot -> InteractionSpecificResult in
                        
                        guard let strongSelf = self else {
                            throw ErrorString("Внутренняя ошибка, смотри код: \(#file):\(#line)")
                        }
                        
                        if let tapEveryNthAttempt = tapEveryNthAttempt, tapEveryNthAttempt > 0, attempt % tapEveryNthAttempt == 0 {
                            let tappableWrapper = try strongSelf.tappableWrapper(
                                elementSnapshot: snapshot,
                                normalizedCoordinate: normalizedCoordinate,
                                absoluteOffset: absoluteOffset
                            )
                            
                            tappableWrapper.tap()
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
    
    private func tappableWrapper(
        elementSnapshot: ElementSnapshot,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?)
        throws
        -> Tappable
    {
        var tapCoordinate = elementSnapshot.frameOnScreen.mb_center
        
        if let normalizedCoordinate = normalizedCoordinate {
            tapCoordinate.x += elementSnapshot.frameOnScreen.width * (normalizedCoordinate.x - 0.5)
            tapCoordinate.y += elementSnapshot.frameOnScreen.height * (normalizedCoordinate.y - 0.5)
        }
        
        if let absoluteOffset = absoluteOffset {
            tapCoordinate.x += absoluteOffset.dx
            tapCoordinate.y += absoluteOffset.dy
        }
        
        // Kludge to fix tapping on "com.apple.springboard"'s alerts.
        // They can not be tapped by coordinate (even with private XCEventGenerator).
        // If there is an alert every tap by coordinate results in alert being dismissed.
        // If you want to tap "Proceed"/"OK" button it will tap "Cancel" button.
        // However, it is possible to interact with XCUIElement inside the alert.
        // We don't want to use XCUIElement for interacting with an element,
        // because it will require to remove abstraction of interfaces
        // that are designed to work with black-box and grey-box testing.
        //
        // But we can find an alert and tap the coordinate relative to it.
        //
        // Note: every action is working this way.
        //
        let uiInterruptionStatus = self.uiInterruptionStatus(snapshot: elementSnapshot)
        
        if uiInterruptionStatus.actionWouldNotWorkDueToUiInterruptionHandling {
            // WARNING: It may use other alert! There may be bugs. Ideally we should find same alert.
            let alert = applicationProvider.application.alerts.element(boundBy: 0)
            
            let alertFrame = alert.frame
            
            if alertFrame.contains(tapCoordinate) {
                let applicationFrame = applicationCoordinatesProvider.frame
                
                tapCoordinate.x -= alertFrame.origin.x - applicationFrame.origin.x
                tapCoordinate.y -= alertFrame.origin.y - applicationFrame.origin.y
            
                return alert
                    .coordinate(withNormalizedOffset: CGVector.zero)
                    .withOffset(CGVector(dx: tapCoordinate.x, dy: tapCoordinate.y))
            } else {
                throw ErrorString("Can not reliably tap system alert by coordinate."
                    + " Try to use pure XCUI functions or use addUIInterruptionMonitor function of XCTestCase")
            }
        } else {
            return applicationCoordinatesProvider.tappableCoordinate(point: tapCoordinate)
        }
    }
    
    // Workaround. See usage for more comments.
    private struct UiInterruptionStatus {
        var actionWouldNotWorkDueToUiInterruptionHandling: Bool {
            return interruptingAlert != nil
        }
        
        // Now only alerts treated as interruptions. Maybe we can reverse engineer XCTest and find
        // the exact algorithm, and maybe we can make more reliable workaround after reverse engineering.
        let interruptingAlert: ElementSnapshot?
    }
    
    private func uiInterruptionStatus(snapshot: ElementSnapshot) -> UiInterruptionStatus {
        var pointer: ElementSnapshot? = snapshot
        while let snapshot = pointer, snapshot.elementType != .alert {
            pointer = snapshot.parent
        }
        
        // Maybe just a comparison of "com.apple.springboard" will work.
        if let snapshot = pointer, snapshot.elementType == .alert && applicationProvider.application.bundleID.starts(with: "com.apple.") {
            return UiInterruptionStatus(interruptingAlert: snapshot)
        } else {
            return UiInterruptionStatus(interruptingAlert: nil)
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
    func normalizedOffsetForSwipe(direction: SwipeDirection) -> CGVector {
        let dxNormalized: CGFloat
        let dyNormalized: CGFloat
        
        switch direction {
        case .up:
            dxNormalized = 0
            dyNormalized = -1
        case .down:
            dxNormalized = 0
            dyNormalized = 1
        case .left:
            dxNormalized = -1
            dyNormalized = 0
        case .right:
            dxNormalized = 1
            dyNormalized = 0
        }
        
        return CGVector(
            dx: dxNormalized,
            dy: dyNormalized
        )
    }
}
