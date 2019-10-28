import MixboxTestsFoundation

public final class SnapshotsDifferenceAttachmentGeneratorImpl: SnapshotsDifferenceAttachmentGenerator {
    private let differenceImageGenerator: DifferenceImageGenerator
    
    public init(differenceImageGenerator: DifferenceImageGenerator) {
        self.differenceImageGenerator = differenceImageGenerator
    }
    
    public func attachments(snapshotsDifferenceDescription: SnapshotsDifferenceDescription) -> [Attachment] {
        var attachments = [
            imageAttachment(
                name: "Actual image",
                image: snapshotsDifferenceDescription.actualImage
            ),
            imageAttachment(
                name: "Expected image",
                image: snapshotsDifferenceDescription.expectedImage
            )
        ]
        
        let differenceImageOrNil = differenceImageGenerator.differenceImage(
            actualImage: snapshotsDifferenceDescription.actualImage,
            expectedImage: snapshotsDifferenceDescription.expectedImage
        )
        
        if let difference = differenceImageOrNil {
            attachments.append(
                imageAttachment(
                    name: "Difference",
                    image: difference
                )
            )
        }
        
        return attachments
    }
    
    private func imageAttachment(name: String, image: UIImage) -> Attachment {
        return Attachment(
            name: name,
            content: .screenshot(image)
        )
    }
}
