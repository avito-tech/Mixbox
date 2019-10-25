import MixboxTestsFoundation
import MixboxFoundation

public final class StepLogBefore: CustomDebugStringConvertible, Equatable {
    public let date: Date
    public let title: String
    public let customData: AnyEquatable
    public let attachments: [Attachment]
    
    public init(
        date: Date,
        title: String,
        customData: AnyEquatable = .void,
        attachments: [Attachment] = [])
    {
        self.date = date
        self.title = title
        self.customData = customData
        self.attachments = attachments
    }
    
    public static func == (lhs: StepLogBefore, rhs: StepLogBefore) -> Bool {
        return lhs.title == rhs.title
            && lhs.date == rhs.date
            && lhs.customData == rhs.customData
            && lhs.attachments == rhs.attachments
    }
    
    public var debugDescription: String {
        return DebugDescriptionBuilder(typeOf: self)
            .add(name: "date", value: date)
            .add(name: "title", value: title)
            .add(name: "customData", value: customData)
            .add(name: "attachments", array: attachments)
            .debugDescription
    }
}
