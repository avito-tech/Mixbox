import XCTest

public final class XctAttachmentsAdderImpl: XctAttachmentsAdder {
    public init() {
    }
    
    public func add(attachment: Attachment, activity: XCTActivity) {
        switch attachment.content {
        case .screenshot(let screenshot):
            add(
                attachment: XCTAttachment(image: screenshot),
                name: attachment.name,
                activity: activity
            )
        case .text(let string):
            add(
                attachment: XCTAttachment(string: string),
                name: attachment.name,
                activity: activity
            )
        case .json(let string):
            add(
                attachment: XCTAttachment(string: string),
                name: attachment.name,
                activity: activity
            )
        case .attachments(let attachments):
            XCTContext.runActivity(named: attachment.name) { activity in
                for attachment in attachments {
                    add(attachment: attachment, activity: activity)
                }
            }
        }
    }
    
    private func add(attachment: XCTAttachment, name: String, activity: XCTActivity) {
        attachment.name = name
        activity.add(attachment)
    }
}
