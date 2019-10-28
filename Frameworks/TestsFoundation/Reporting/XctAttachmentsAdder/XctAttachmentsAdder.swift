import XCTest

public protocol XctAttachmentsAdder {
    func add(attachment: Attachment, activity: XCTActivity)
}

extension XctAttachmentsAdder {
    public func add(attachments: [Attachment], activity: XCTActivity) {
        attachments.forEach { attachment in
            add(attachment: attachment, activity: activity)
        }
    }
}
