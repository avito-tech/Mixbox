import MixboxTestsFoundation

public protocol ScreenshotAttachmentsMaker: class {
    func makeScreenshotAttachments(
        beforeStep: Bool,
        includeHash: Bool)
        -> [Attachment]
}

public final class ScreenshotAttachmentsMakerImpl: ScreenshotAttachmentsMaker {
    private let imageHashCalculator: ImageHashCalculator
    private let screenshotTaker: ScreenshotTaker
    
    public init(
        imageHashCalculator: ImageHashCalculator,
        screenshotTaker: ScreenshotTaker)
    {
        self.imageHashCalculator = imageHashCalculator
        self.screenshotTaker = screenshotTaker
    }
    
    public func makeScreenshotAttachments(
        beforeStep: Bool,
        includeHash: Bool)
        -> [Attachment]
    {
        var attachments = [Attachment]()
        
        if let screenshot = screenshotTaker.takeScreenshot() {
            let screenshotAttachment = Attachment(
                name: attachmentNameAndCircumstances(
                    attachmentName: "Скриншот",
                    beforeStep: beforeStep
                ),
                content: .screenshot(screenshot)
            )
            
            attachments.append(screenshotAttachment)
            
            // Simplifies error classification
            if includeHash {
                let screenshotHash = imageHashCalculator.imageHash(image: screenshot)
                let screenshotHashAttachment = Attachment(
                    name: attachmentNameAndCircumstances(
                        attachmentName: "hash скриншота \(type(of: imageHashCalculator))",
                        beforeStep: beforeStep
                    ),
                    content: .text("\(screenshotHash)")
                )
                attachments.append(screenshotHashAttachment)
            }
        }
        
        return attachments
    }
    
    private func attachmentNameAndCircumstances(
        attachmentName: String,
        beforeStep: Bool)
        -> String
    {
        let interactionTime = beforeStep ? "до" : "после"
        
        return "\(attachmentName) \(interactionTime)"
    }
}
