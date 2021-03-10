import MixboxTestsFoundation

public protocol SnapshotsDifferenceAttachmentGenerator {
    func attachments(snapshotsDifferenceDescription: SnapshotsDifferenceDescription) -> [Attachment]
}
