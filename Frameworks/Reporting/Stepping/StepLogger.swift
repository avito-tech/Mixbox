import MixboxArtifacts

public final class StepLoggerWrappedResult<T> {
    public let stepLogAfter: StepLogAfter
    public let wrappedResult: T
    
    public init(
        stepLogAfter: StepLogAfter,
        wrappedResult: T)
    {
        self.stepLogAfter = stepLogAfter
        self.wrappedResult = wrappedResult
    }
}

// Допустим, есть код:
//
// let myResult: (MyResult) = getMyResult() // Не optional
// return myResult
//
// Можно его положить в логируемый шаг:
//
// let myResult: (MyResult) = stepLogger.logStep {
//     let myResult = getMyResult()
//     return StepLoggerWrappedCodeResult(
//         stepLogAfter = StepLogAfter(
//             wasSuccessful: myResult.someCombinableStuff.reduce(true) { $0 && $1 }
//             artifacts: myResult.getArtifacts() + makeDefaultArtifacts()
//         )
//     )
// }
//
// На выходе получаем то, что и раньше, при том что вклинились в процесс со своим логгированием
//
public protocol StepLogger {
    func logStep<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerWrappedResult<T>)
        -> T
}

public extension StepLogger {
    // Для простой записи в логе без древовидности
    func logEntry(
        date: Date = Date(),
        description: String,
        artifacts: [Artifact])
    {
        let stepLogBefore = StepLogBefore.other(description, artifacts: artifacts, date: date)
        logStep(stepLogBefore: stepLogBefore) { () -> StepLoggerWrappedResult<()> in
            StepLoggerWrappedResult(
                stepLogAfter: StepLogAfter(
                    wasSuccessful: true,
                    artifacts: []
                ),
                wrappedResult: ()
            )
        }
    }
}

public enum StepType {
    case testWarehouseStep
    case testWarehouseAssertion
    case testWarehousePrecondition
    case interaction
    case other
}

public final class StepLogBefore {
    public let date: Date
    public let identifyingDescription: String // Для идентификации шага
    public let detailedDescription: String // Произвольное описание
    public let stepType: StepType
    public let artifacts: [Artifact]
    
    public init(
        date: Date = Date(),
        identifyingDescription: String,
        detailedDescription: String,
        stepType: StepType,
        artifacts: [Artifact])
    {
        self.date = date
        self.identifyingDescription = identifyingDescription
        self.detailedDescription = detailedDescription
        self.stepType = stepType
        self.artifacts = artifacts
    }
    
    public static func other(_ description: String, artifacts: [Artifact] = [], date: Date = Date()) -> StepLogBefore {
        return StepLogBefore(
            date: date,
            identifyingDescription: description,
            detailedDescription: description,
            stepType: .other,
            artifacts: artifacts
        )
    }
}

public final class StepLogAfter {
    public let date: Date
    public let wasSuccessful: Bool
    public let artifacts: [Artifact]
    
    public init(
        date: Date = Date(),
        wasSuccessful: Bool,
        artifacts: [Artifact])
    {
        self.date = date
        self.wasSuccessful = wasSuccessful
        self.artifacts = artifacts
    }
}
