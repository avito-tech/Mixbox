import MixboxArtifacts
import MixboxFoundation

public final class StepLogAfter: CustomDebugStringConvertible, Equatable {
    public let date: Date
    public let wasSuccessful: Bool
    public let customData: AnyEquatable
    public let artifacts: [Artifact]
    
    public init(
        date: Date = Date(),
        wasSuccessful: Bool,
        customData: AnyEquatable = .void,
        artifacts: [Artifact] = [])
    {
        self.date = date
        self.wasSuccessful = wasSuccessful
        self.customData = customData
        self.artifacts = artifacts
    }
    
    public static func ==(lhs: StepLogAfter, rhs: StepLogAfter) -> Bool {
        return lhs.date == rhs.date
            && lhs.wasSuccessful == rhs.wasSuccessful
            && lhs.customData == rhs.customData
            && lhs.artifacts == rhs.artifacts
    }
    
    public var debugDescription: String {
       return DebugDescriptionBuilder(typeOf: self)
            .add(name: "date", value: date)
            .add(name: "wasSuccessful", value: wasSuccessful)
            .add(name: "customData", value: customData)
            .add(name: "artifacts", array: artifacts)
            .debugDescription
    }
}
