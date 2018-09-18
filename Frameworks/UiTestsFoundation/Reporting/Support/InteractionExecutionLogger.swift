import MixboxTestsFoundation
import MixboxArtifacts
import MixboxReporting
import MixboxFoundation

public protocol InteractionExecutionLogger: class  {
    func logInteraction(
        interactionDescription: InteractionDescription,
        body: () -> InteractionResult)
        -> InteractionResult
}

public final class InteractionExecutionLoggerImpl: InteractionExecutionLogger {
    private let stepLogger: StepLogger
    private let screenshotTaker: ScreenshotTaker
    
    public init(
        stepLogger: StepLogger,
        screenshotTaker: ScreenshotTaker)
    {
        self.stepLogger = stepLogger
        self.screenshotTaker = screenshotTaker
    }
    
    // MARK: - InteractionExecutionLogger
    
    public func logInteraction(
        interactionDescription: InteractionDescription,
        body: () -> InteractionResult)
        -> InteractionResult
    {
        let stepLogBefore = StepLogBefore(
            identifyingDescription: interactionDescription.settings.interactionName,
            detailedDescription: interactionDescription.settings.interactionName,
            stepType: .interaction,
            artifacts: takeScreenshot(
                interactionDescription: interactionDescription,
                before: true
            )
        )
        
        return stepLogger.logStep(stepLogBefore: stepLogBefore) {
            let interactionResult = body()
            
            let wasSuccessful: Bool
            var stepArtifacts: [Artifact] = takeScreenshot(
                interactionDescription: interactionDescription,
                before: false
            )
            
            stepArtifacts.append(
                fileLineArtifact(fileLine: interactionDescription.settings.fileLineWhereExecuted)
            )
            
            switch interactionResult {
                case .success:
                    wasSuccessful = true
                case .failure(let interactionFailure):
                    stepArtifacts.append(
                        contentsOf: artifacts(
                            interactionFailure: interactionFailure,
                            fileLine: interactionDescription.settings.fileLineWhereExecuted
                        )
                    )
                    wasSuccessful = false
            }
            
            return StepLoggerWrappedResult(
                stepLogAfter: StepLogAfter(
                    wasSuccessful: wasSuccessful,
                    artifacts: stepArtifacts
                ),
                wrappedResult: interactionResult
            )
        }
    }
    
    // MARK: - Private
    
    private func takeScreenshot(interactionDescription: InteractionDescription, before: Bool) -> [Artifact] {
        let interactionTypeGenitiveCase: String
        
        switch interactionDescription.type {
        case .action:
            interactionTypeGenitiveCase = "действия"
        case .check:
            interactionTypeGenitiveCase = "проверки"
        }
        
        let interactionTime = before ? "до" : "после"
    
        if let screenshot = screenshotTaker.takeScreenshot() {
            let artifact = Artifact(
                name: "Скриншот \(interactionTime) \(interactionTypeGenitiveCase)",
                content: .screenshot(screenshot)
            )
            return [artifact]
        } else {
            return []
        }
    }
    
    private func fileLineArtifact(fileLine: FileLine) -> Artifact {
        return Artifact(
            name: "Строка и файл",
            content: .text("\(fileLine.file):\(fileLine.line)")
        )
    }
    
    private func artifacts(
        interactionFailure: InteractionFailure,
        fileLine: FileLine)
        -> [Artifact]
    {
        var artifacts = [Artifact]()
        
        if let error = interactionFailure.error {
            artifacts.append(
                Artifact(
                    name: "Ошибка",
                    content: .text(String(describing: error))
                )
            )
        }
        
        if let applicationUiHierarchy = interactionFailure.applicationUiHierarchy {
            artifacts.append(
                Artifact(
                    name: "Иерархия вьюх",
                    content: .text(applicationUiHierarchy)
                )
            )
        }
        
        if let betterUiHierarchy = interactionFailure.betterUiHierarchy {
            artifacts.append(
                Artifact(
                    name: "betterUiHierarchy",
                    content: .text(betterUiHierarchy)
                )
            )
        }
        
        if !interactionFailure.stackTrace.isEmpty {
            artifacts.append(
                Artifact(
                    name: "Stack trace",
                    content: .text(interactionFailure.stackTrace.joined(separator: "\n"))
                )
            )
        }
        
        if let specificFailure = interactionFailure.interactionSpecificFailure {
            artifacts.append(
                Artifact(
                    name: "Подробное описание ошибки конкретного взаимодействия с UI",
                    content: .text(specificFailure.message)
                )
            )
            
            artifacts.append(contentsOf: specificFailure.artifacts)
        }
        
        artifacts.append(
            Artifact(
                name: "Сообщение об ошибке",
                content: .text("\(fileLine.file):\(fileLine.line): \(interactionFailure.message))")
            )
        )
        
        return artifacts
    }
}
