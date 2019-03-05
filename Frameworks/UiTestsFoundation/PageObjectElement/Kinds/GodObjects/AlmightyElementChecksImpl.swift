import MixboxTestsFoundation
import MixboxReporting
import MixboxArtifacts

public final class AlmightyElementChecksImpl: AlmightyElementChecks {
    private let elementSettings: ElementSettings
    private let isAssertions: Bool
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    private let pollingConfiguration: PollingConfiguration
    
    public init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory,
        isAssertions: Bool,
        pollingConfiguration: PollingConfiguration)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
        self.isAssertions = isAssertions
        self.pollingConfiguration = pollingConfiguration
    }
    
    // MARK: - AlmightyElementChecks
    
    public func with(settings: ElementSettings) -> AlmightyElementChecks {
        return AlmightyElementChecksImpl(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory,
            isAssertions: isAssertions,
            pollingConfiguration: pollingConfiguration
        )
    }
    
    public func isDisplayedAndMatches(
        checkSettings: CheckSettings,
        minimalPercentageOfVisibleArea: CGFloat,
        matcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
        -> Bool
    {
        let interaction = interactionFactory.checkInteraction(
            specificImplementation: InteractionSpecificImplementation { snapshot in
                let matcher = ElementMatcherBuilder.build(matcher)
                
                switch matcher.matches(value: snapshot) {
                case .match:
                    return .success
                case let .mismatch(_, mismatchDescription):
                    return .failureWithMessage(
                        "Проверка неуспешна: \(mismatchDescription())"
                    )
                }
            },
            settings: resolvedInteractionSettings(interactionSettings: checkSettings),
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
        
        return perform(interaction: interaction)
    }
    
    public func isNotDisplayed(checkSettings: CheckSettings) -> Bool {
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
    
    // MARK: - Private
    
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
}

private func interactionSpecificResult(
    _ failure: SnapshotsComparisonFailure)
    -> InteractionSpecificResult
{
    var artifacts = [Artifact]()
    
    func add(_ image: UIImage?, _ name: String) {
        if let image = image {
            artifacts.append(
                Artifact(
                    name: name,
                    content: .screenshot(image)
                )
            )
        }
    }
    
    add(failure.expectedImage, "Ожидаемое изображение")
    add(failure.actualImage, "Актуальное изображение")
    add(failure.differenceImage, "Разница между актуальным и ожидаемым изображением")
    
    return .failure(
        InteractionSpecificFailure(
            message: "Скриншот не совпадает с референсным",
            artifacts: artifacts
        )
    )
}
