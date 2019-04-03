import MixboxArtifacts

public final class StepLog: CustomDebugStringConvertible, Equatable {
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
    
    public var debugDescription: String {
        let stepsDescription = steps
            .map { $0.debugDescription }
            .joined(separator: "\n")
            .mb_wrapAndIndent(prefix: "[", postfix: "    ]", indentation: String(repeating: " ", count: 8), ifEmpty: "[]")
        
        return """
            StepLog(
                identifyingDescription: \(identifyingDescription.debugDescription),
                detailedDescription: \(detailedDescription.debugDescription),
                stepType: \(stepType),
                startDate: \(startDate.debugDescription),
                stopDate: \(stopDate.debugDescription),
                wasSuccessful: \(wasSuccessful),
                artifactsBefore: \(artifactsBefore.debugDescription),
                artifactsAfter: \(artifactsAfter.debugDescription),
                steps: \(stepsDescription),
            )
            """
    }
    
    public static func ==(lhs: StepLog, rhs: StepLog) -> Bool {
        return lhs.identifyingDescription == rhs.identifyingDescription
            && lhs.detailedDescription == rhs.detailedDescription
            && lhs.stepType == rhs.stepType
            && lhs.startDate == rhs.startDate
            && lhs.stopDate == rhs.stopDate
            && lhs.wasSuccessful == rhs.wasSuccessful
            && lhs.artifactsBefore == rhs.artifactsBefore
            && lhs.artifactsAfter == rhs.artifactsAfter
            && lhs.steps == rhs.steps
    }
}
