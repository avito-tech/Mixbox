import MixboxArtifacts

public final class StepLog {
    // TODO: Explain the difference:
    public let identifyingDescription: String // For identifying a step
    public let detailedDescription: String // Anything
    
    public let stepType: StepType
    public let startDate: Date
    public let stopDate: Date?
    public let wasSuccessful: Bool
    public let artifactsBefore: [Artifact]
    public let artifactsAfter: [Artifact]
    public let steps: [StepLog]
    
    public init(
        identifyingDescription: String,
        detailedDescription: String,
        stepType: StepType,
        startDate: Date,
        stopDate: Date?,
        wasSuccessful: Bool,
        artifactsBefore: [Artifact],
        artifactsAfter: [Artifact],
        steps: [StepLog])
    {
        self.identifyingDescription = identifyingDescription
        self.detailedDescription = detailedDescription
        self.stepType = stepType
        self.startDate = startDate
        self.stopDate = stopDate
        self.wasSuccessful = wasSuccessful
        self.artifactsBefore = artifactsBefore
        self.artifactsAfter = artifactsAfter
        self.steps = steps
    }
}
