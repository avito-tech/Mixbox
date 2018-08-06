import MixboxUiTestsFoundation
import MixboxTestsFoundation
import AutoMate
import MixboxIpcCommon
import MixboxReporting

// TODO: Rename UiAutomation to Xcui
// TODO: Split the class
final class UiAutomationPageObjectElementChecks: AlmightyElementChecks {
    private let elementSettings: ElementSettings
    private let isAssertions: Bool
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let snapshotsComparisonUtility: SnapshotsComparisonUtility
    private let stepLogger: StepLogger
    
    init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        elementVisibilityChecker: ElementVisibilityChecker,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        stepLogger: StepLogger,
        isAssertions: Bool)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.elementVisibilityChecker = elementVisibilityChecker
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.stepLogger = stepLogger
        self.isAssertions = isAssertions
    }
    
    // MARK: - Private
    
    private func performCheck(
        checkSettings: CheckSettings,
        minimalPercentageOfVisibleArea: CGFloat = 0.2,
        check: @escaping (_ element: XCUIElement, _ snapshot: ElementSnapshot) -> InteractionSpecificResult)
        -> Bool
    {
        let interaction = interactionFactory.checkInteraction(
            specificImplementation: InteractionSpecificImplementation(execute: check),
            settings: resolvedInteractionSettings(interactionSettings: checkSettings),
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
        
        return perform(interaction: interaction)
    }
    
    private func resolvedInteractionSettings(interactionSettings: InteractionSettings) -> ResolvedInteractionSettings {
        return ResolvedInteractionSettings(
            interactionSettings: interactionSettings,
            elementSettings: elementSettings
        )
    }
    
    private func perform(interaction: Interaction) -> Bool {
        let interactionPerformer = interactionPerformerFactory.performerForInteraction(
            shouldReportResultToObserver: isAssertions
        )
        
        let result = interactionPerformer.performInteraction(interaction: interaction)
        
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    // MARK: - AlmightyElementChecks
    
    func with(settings: ElementSettings) -> AlmightyElementChecks {
        return UiAutomationPageObjectElementChecks(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            elementVisibilityChecker: elementVisibilityChecker,
            snapshotsComparisonUtility: snapshotsComparisonUtility,
            stepLogger: stepLogger,
            isAssertions: isAssertions
        )
    }
    
    func checkText(checker: @escaping (String) -> (InteractionSpecificResult), checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) {
            (_: XCUIElement, snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            checker(snapshot.visibleText(fallback: snapshot.label))
        }
    }
    
    func checkAccessibilityLabel(checker: @escaping (String) -> (InteractionSpecificResult), checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) {
            (_: XCUIElement, snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            checker(snapshot.label ?? "")
        }
    }
    
    func isNotDisplayed(checkSettings: CheckSettings) -> Bool {
        return perform(
            interaction: interactionFactory.checkForNotDisplayedInteraction(
                settings: resolvedInteractionSettings(interactionSettings: checkSettings),
                // Пример: если 0.42, то все, что будет видно более (>=) чем на 42% будет фейлить проверку.
                // Если элемент будет виден на 41%, то мы посчитаем проверку успешной.
                // Пример: если 0.0, то будет видимым всегда посчитается видимым (0.0 >= 0.0).
                // Поэтому сейчас такое значение:
                minimalPercentageOfVisibleArea: 0.00001
            )
        )
    }
    
    func isDisplayed(checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) { _, _  in
            .success // без специфики, проверка на видимость встроена по дефолту
        }
    }
    
    func hasValue(_ expectedValue: String, checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) {
            (_: XCUIElement, snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            let elementValue = snapshot.originalAccessibilityValue
            
            if elementValue == expectedValue {
                return .success
            } else {
                let elementValueAsString: String = elementValue ?? "nil"
                
                return .failureWithMessage("ожидалось: \(expectedValue), актуальное: \(elementValueAsString)")
            }
        }
    }
    
    func hasHostDefinedValue(
        forKey key: String,
        referenceValue: String,
        checkSettings: CheckSettings,
        comparator: HostDefinedValueComparator)
        -> Bool
    {
        return performCheck(checkSettings: checkSettings) {
            (_: XCUIElement, snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            let hostedValues = snapshot.hostDefinedValues
            let hostedValue = hostedValues[key]
            
            if comparator.compare(hostedValue: hostedValue, referenceValue: referenceValue) {
                return .success
            } else {
                let hostedValueAsString: String = hostedValue ?? "nil"
                
                // TODO: Сообщение должно быть специфично для проверки. Пока подходит только для равенства.
                return .failureWithMessage(
                    "проверка не прошла, референсное значение: \(referenceValue), актуальное: \(hostedValueAsString)"
                )
            }
        }
    }
    
    func isEnabled(checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) {
            (_: XCUIElement, snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            if snapshot.enabled {
                return .success
            } else {
                return .failureWithMessage("enabled ожидалось true, актуально false")
            }
        }
    }
    
    func isDisabled(checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) {
            (_: XCUIElement, snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            if !snapshot.enabled {
                return .success
            } else {
                return .failureWithMessage("enabled ожидалось false, актуально true")
            }
        }
    }
    
    func hasImage(_ image: UIImage, checkSettings: CheckSettings) -> Bool {
        XCTFail("Not implemented yet")
        // TODO
        return false
    }
    
    func hasAnyImage(checkSettings: CheckSettings) -> Bool {
        XCTFail("Not implemented yet")
        // TODO
        return false
    }
    
    func hasNoImage(checkSettings: CheckSettings) -> Bool {
        XCTFail("Not implemented yet")
        // TODO
        return false
    }
    
    func isScrollable(checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) {
            (_: XCUIElement, snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            // Странная проверка. По факту скроллвью может не скроллиться, а нескроллвью скроллиться.
            if snapshot.elementType == .scrollView {
                return .success
            } else {
                return .failureWithMessage("elementType ожидался 'scrollView', актуальный: '\(snapshot.elementType)'")
            }
        }
    }
    
    func matchesReference(snapshot snapshotName: String, checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings, minimalPercentageOfVisibleArea: 1) {
            [weak self] (element: XCUIElement, _: ElementSnapshot) -> InteractionSpecificResult in
            
            let filePath = checkSettings.fileLineWhereExecuted.file.description
            
            guard let folderName = filePath.split(separator: "/").last?.split(separator: ".").first else {
                return .failureWithMessage("Не обнаружено папки с референсными скриншотами")
            }
            
            sleep(1)  // Waiting for the animation to be finished (kind of)
            
            guard let strongSelf = self else {
                return .failureWithMessage("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let result = strongSelf.snapshotsComparisonUtility.compare(
                actual: element.screenshot().image,
                folder: String(folderName),
                file: snapshotName
            )
            
            if case .passed = result {
                return .success
            } else {
                // TODO: в snapshotsComparisonUtility добавить поддержку отчетов со скринами,
                // показывающими разницу
                return .failureWithMessage("Скриншот не совпадает с референсным")
            }
        }
    }
    
    func matchesReference(image: UIImage, checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings, minimalPercentageOfVisibleArea: 0.0) {
            [weak self] (element: XCUIElement, _: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                return .failureWithMessage("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let result = strongSelf.snapshotsComparisonUtility.compare(
                actual: element.screenshot().image,
                reference: image
            )
            
            if case .passed = result {
                return .success
            } else {
                // TODO: в snapshotsComparisonUtility добавить поддержку отчетов со скринами,
                // показывающими разницу
                return .failureWithMessage("Скриншот не совпадает с референсным")
            }
        }
    }
}
