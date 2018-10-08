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
    private let imageHashCalculator: ImageHashCalculator
    
    public init(
        stepLogger: StepLogger,
        screenshotTaker: ScreenshotTaker,
        imageHashCalculator: ImageHashCalculator)
    {
        self.stepLogger = stepLogger
        self.screenshotTaker = screenshotTaker
        self.imageHashCalculator = imageHashCalculator
    }
    
    // MARK: - InteractionExecutionLogger
    
    public func logInteraction(
        interactionDescription: InteractionDescription,
        body: () -> InteractionResult)
        -> InteractionResult
    {
        let stepLogBefore = self.stepLogBefore(
            interactionDescription: interactionDescription
        )
        
        return stepLogger.logStep(stepLogBefore: stepLogBefore) {
            let interactionResult = body()
            
            return StepLoggerWrappedResult(
                stepLogAfter: stepLogAfter(
                    interactionDescription: interactionDescription,
                    interactionResult: interactionResult
                ),
                wrappedResult: interactionResult
            )
        }
    }
    
    // MARK: - Private
    
    private func stepLogBefore(interactionDescription: InteractionDescription) -> StepLogBefore {
        return StepLogBefore(
            identifyingDescription: interactionDescription.settings.interactionName,
            detailedDescription: interactionDescription.settings.interactionName,
            stepType: .interaction,
            artifacts: makeScreenshotArtifacts(
                interactionDescription: interactionDescription,
                beforeStep: true,
                includeHash: false
            )
        )
    }
    
    private func stepLogAfter(
        interactionDescription: InteractionDescription,
        interactionResult: InteractionResult)
        -> StepLogAfter
    {
        
        let wasSuccessful: Bool
        var stepArtifacts = [Artifact]()
        
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
        
        stepArtifacts.append(
            contentsOf: makeScreenshotArtifacts(
                interactionDescription: interactionDescription,
                beforeStep: false,
                includeHash: !wasSuccessful
            )
        )
        
        return StepLogAfter(
            wasSuccessful: wasSuccessful,
            artifacts: stepArtifacts
        )
    }
    
    private func makeScreenshotArtifacts(
        interactionDescription: InteractionDescription,
        beforeStep: Bool,
        includeHash: Bool)
        -> [Artifact]
    {
        var artifacts = [Artifact]()
        
        if let screenshot = screenshotTaker.takeScreenshot() {
            let screenshotArtifact = Artifact(
                name: artifactNameAndCircumstances(
                    artifactName: "Скриншот",
                    interactionDescription: interactionDescription,
                    beforeStep: beforeStep
                ),
                content: .screenshot(screenshot)
            )
            
            artifacts.append(screenshotArtifact)
            
            // Simplifies error classification
            if includeHash {
                let screenshotHash = imageHashCalculator.imageHash(image: screenshot)
                let screenshotHashArtifact = Artifact(
                    name: artifactNameAndCircumstances(
                        artifactName: "hash скриншота \(type(of: imageHashCalculator))",
                        interactionDescription: interactionDescription,
                        beforeStep: beforeStep
                    ),
                    content: .text("\(screenshotHash)")
                )
                artifacts.append(screenshotHashArtifact)
            }
        }
        
        return artifacts
    }
    
    private func artifactNameAndCircumstances(
        artifactName: String,
        interactionDescription: InteractionDescription,
        beforeStep: Bool)
        -> String
    {
        let interactionTypeGenitiveCase: String
        
        switch interactionDescription.type {
        case .action:
            interactionTypeGenitiveCase = "действия"
        case .check:
            interactionTypeGenitiveCase = "проверки"
        }
        
        let interactionTime = beforeStep ? "до" : "после"
        
        return "\(artifactName) \(interactionTime) \(interactionTypeGenitiveCase)"
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
