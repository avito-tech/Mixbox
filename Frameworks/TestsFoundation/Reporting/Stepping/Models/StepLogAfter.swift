import MixboxTestsFoundation
import MixboxFoundation

public final class StepLogAfter: CustomDebugStringConvertible, Equatable {
    public let date: Date
    public let wasSuccessful: Bool
    public let customData: AnyEquatable
    public let attachments: [Attachment]
    
    public init(
        date: Date,
        wasSuccessful: Bool,
        customData: AnyEquatable = .void,
        attachments: [Attachment] = [])
    {
        self.date = date
        self.wasSuccessful = wasSuccessful
        self.customData = customData
        self.attachments = attachments
    }
    
    public static func ==(lhs: StepLogAfter, rhs: StepLogAfter) -> Bool {
        return lhs.date == rhs.date
            && lhs.wasSuccessful == rhs.wasSuccessful
            && lhs.customData == rhs.customData
            && lhs.attachments == rhs.attachments
    }
    
    public var debugDescription: String {
       return DebugDescriptionBuilder(typeOf: self)
            .add(name: "date", value: date)
            .add(name: "wasSuccessful", value: wasSuccessful)
            .add(name: "customData", value: customData)
            .add(name: "attachments", array: attachments)
            .debugDescription
    }
}
