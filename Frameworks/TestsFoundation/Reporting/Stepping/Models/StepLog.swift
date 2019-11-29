import MixboxFoundation

public final class StepLog: CustomDebugStringConvertible, Equatable {
    public let before: StepLogBefore
    public let after: StepLogAfter?
    public let steps: [StepLog]
    
    public init(
        before: StepLogBefore,
        after: StepLogAfter?,
        steps: [StepLog])
    {
        self.before = before
        self.after = after
        self.steps = steps
    }
    
    public var debugDescription: String {
        return DebugDescriptionBuilder(typeOf: self)
            .add(name: "before", value: before)
            .add(name: "after", value: after)
            .add(name: "steps", array: steps)
            .debugDescription
    }
    
    public static func ==(lhs: StepLog, rhs: StepLog) -> Bool {
        return lhs.before == rhs.before
            && lhs.after == rhs.after
            && lhs.steps == rhs.steps
    }
}

extension StepLog {
    public var title: String {
        return before.title
    }
    
    public var wasSuccessful: Bool {
        return after?.wasSuccessful ?? false
    }
    
    public var startDate: Date {
        return before.date
    }
    
    public var stopDate: Date? {
        return after?.date
    }
    
    public var attachmentsBefore:[Attachment] {
        return before.attachments
    }
    
    public var attachmentsAfter: [Attachment] {
        return after?.attachments ?? []
    }
}
