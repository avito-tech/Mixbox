import MixboxArtifacts
import MixboxFoundation

public final class StepLogBefore: CustomDebugStringConvertible, Equatable {
    public let date: Date
    public let title: String
    public let customData: AnyEquatable
    public let artifacts: [Artifact]
    
    public init(
        date: Date,
        title: String,
        customData: AnyEquatable = .void,
        artifacts: [Artifact] = [])
    {
        self.date = date
        self.title = title
        self.customData = customData
        self.artifacts = artifacts
    }
    
    public static func == (lhs: StepLogBefore, rhs: StepLogBefore) -> Bool {
        return lhs.title == rhs.title
            && lhs.date == rhs.date
            && lhs.customData == rhs.customData
            && lhs.artifacts == rhs.artifacts
    }
    
    public var debugDescription: String {
        return DebugDescriptionBuilder(typeOf: self)
            .add(name: "date", value: date)
            .add(name: "title", value: title)
            .add(name: "customData", value: customData)
            .add(name: "artifacts", array: artifacts)
            .debugDescription
    }
}
