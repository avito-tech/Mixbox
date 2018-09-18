import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxIpcCommon
import MixboxReporting

// TODO: Split the class
final class XcuiPageObjectElementChecks: AlmightyElementChecks {
    private let elementSettings: ElementSettings
    private let isAssertions: Bool
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let snapshotsComparisonUtility: SnapshotsComparisonUtility
    private let stepLogger: StepLogger
    private let pollingConfiguration: PollingConfiguration
    
    init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        elementVisibilityChecker: ElementVisibilityChecker,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        stepLogger: StepLogger,
        isAssertions: Bool,
        pollingConfiguration: PollingConfiguration)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.elementVisibilityChecker = elementVisibilityChecker
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.stepLogger = stepLogger
        self.isAssertions = isAssertions
        self.pollingConfiguration = pollingConfiguration
    }
    
    // MARK: - Private
    
    @discardableResult
    private func performCheck(
        checkSettings: CheckSettings,
        minimalPercentageOfVisibleArea: CGFloat = 0.2,
        check: @escaping (_ snapshot: ElementSnapshot) -> InteractionSpecificResult)
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
            elementSettings: elementSettings,
            pollingConfiguration: pollingConfiguration
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
    
    private func checkPositiveHeightDifference(
        action: @escaping () -> (),
        differenceCalculation: @escaping ((initial: CGFloat, final: CGFloat)) -> (CGFloat),
        negativeDifferenceFailureMessage: @escaping (CGFloat) -> (String),
        checkSettings: CheckSettings) 
        -> Bool 
    {
        return performCheck(
            checkSettings: checkSettings,
            check: { [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
                guard let strongSelf = self else {
                    return .failureWithMessage("Внутренняя ошибка, смотри код: \(#file):\(#line)")
                }

                let initialHeight = snapshot.frameOnScreen.height
                action()
                strongSelf.performCheck(
                    checkSettings: checkSettings,
                    check: { (snapshot: ElementSnapshot) -> InteractionSpecificResult in
                        let heightDifference = differenceCalculation(
                            (
                                initial: initialHeight,
                                final: snapshot.frameOnScreen.height
                            )
                        )
                        return heightDifference > 0
                            ? .success
                            : .failureWithMessage(negativeDifferenceFailureMessage(heightDifference))
                    }
                )
                return .success
            }
        )
    }
    
    // MARK: - AlmightyElementChecks
    
    func with(settings: ElementSettings) -> AlmightyElementChecks {
        return XcuiPageObjectElementChecks(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            elementVisibilityChecker: elementVisibilityChecker,
            snapshotsComparisonUtility: snapshotsComparisonUtility,
            stepLogger: stepLogger,
            isAssertions: isAssertions,
            pollingConfiguration: pollingConfiguration
        )
    }
    
    func matches(
        checkSettings: CheckSettings,
        minimalPercentageOfVisibleArea: CGFloat,
        matcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
        -> Bool
    {
        return performCheck(checkSettings: checkSettings, minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea) { snapshot in
            let matcher = ElementMatcherBuilder.build(matcher)
            
            switch matcher.matches(value: snapshot) {
            case .match:
                return .success
            case let .mismatch(_, mismatchDescription):
                return .failureWithMessage(
                    "проверка не прошла: \(mismatchDescription())"
                )
            }
        }
    }
    
    func checkText(checker: @escaping (String) -> (InteractionSpecificResult), checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) { (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            checker(snapshot.visibleText(fallback: snapshot.accessibilityLabel) ?? "")
        }
    }
    
    func checkAccessibilityLabel(checker: @escaping (String) -> (InteractionSpecificResult), checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) { (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            checker(snapshot.accessibilityLabel)
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
        return performCheck(checkSettings: checkSettings) { _  in
            .success // без специфики, проверка на видимость встроена по дефолту
        }
    }
    
    func isInHierarchy(checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings, minimalPercentageOfVisibleArea: 0.0) { _ in
            .success // без специфики, проверка на видимость встроена по дефолту
        }
    }

    func becomesTallerAfter(action: @escaping () -> (), checkSettings: CheckSettings) -> Bool {
        return checkPositiveHeightDifference(
            action: action,
            differenceCalculation: { initial, final in
                final - initial    
            }, 
            negativeDifferenceFailureMessage: { difference in
                "ожидалось, что элемент увеличится в высоту, но он уменьшился на \(abs(difference))"
            },
            checkSettings: checkSettings
        )
    }
    
    func becomesShorterAfter(action: @escaping () -> (), checkSettings: CheckSettings) -> Bool {
        return checkPositiveHeightDifference(
            action: action,
            differenceCalculation: { initial, final in
                initial - final
            },
            negativeDifferenceFailureMessage: { difference in
                "ожидалось, что элемент уменьшится в высоту, но он увеличился на \(abs(difference))"
            },
            checkSettings: checkSettings
        )
    }

    func hasValue(_ expectedValue: String, checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) { (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            let elementValue = snapshot.accessibilityValue as? String
            
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
            (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            let customValue = snapshot.customValues.value?[key]
            
            if comparator.compare(hostedValue: customValue, referenceValue: referenceValue) {
                return .success
            } else {
                let hostedValueAsString: String = customValue ?? "nil"
                
                // TODO: Сообщение должно быть специфично для проверки. Пока подходит только для равенства.
                return .failureWithMessage(
                    "проверка не прошла, референсное значение: \(referenceValue), актуальное: \(hostedValueAsString)"
                )
            }
        }
    }
    
    func isEnabled(checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) { (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            if snapshot.isEnabled {
                return .success
            } else {
                return .failureWithMessage("enabled ожидалось true, актуально false")
            }
        }
    }
    
    func isDisabled(checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings) {  (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            if !snapshot.isEnabled {
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
        return performCheck(checkSettings: checkSettings) { (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            // Странная проверка. По факту скроллвью может не скроллиться, а нескроллвью скроллиться.
            if snapshot.elementType == .scrollView {
                return .success
            } else {
                let elementTypeString = snapshot.elementType.flatMap { "\($0)" } ?? "nil"
                return .failureWithMessage("elementType ожидался 'scrollView', актуальный: '\(elementTypeString)'")
            }
        }
    }
    
    func matchesReference(snapshot snapshotName: String, checkSettings: CheckSettings) -> Bool {
        return performCheck(checkSettings: checkSettings, minimalPercentageOfVisibleArea: 1) {
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                return .failureWithMessage("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            let filePath = checkSettings.fileLineWhereExecuted.file.description
            
            guard let folderName = filePath.split(separator: "/").last?.split(separator: ".").first else {
                return .failureWithMessage("Не обнаружено папки с референсными скриншотами")
            }
            
            guard let actualImage = snapshot.image() else {
                return .failureWithMessage("Не удалось создать картинку по элементу \(snapshot)")
            }
            
            sleep(1)  // Waiting for the animation to be finished (kind of)
            
            let result = strongSelf.snapshotsComparisonUtility.compare(
                actual: actualImage,
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
            [weak self] (snapshot: ElementSnapshot) -> InteractionSpecificResult in
            
            guard let strongSelf = self else {
                return .failureWithMessage("Внутренняя ошибка, смотри код: \(#file):\(#line)")
            }
            
            guard let actualImage = snapshot.image() else {
                return .failureWithMessage("Не удалось создать картинку по элементу \(snapshot)")
            }
            
            let result = strongSelf.snapshotsComparisonUtility.compare(
                actual: actualImage,
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
