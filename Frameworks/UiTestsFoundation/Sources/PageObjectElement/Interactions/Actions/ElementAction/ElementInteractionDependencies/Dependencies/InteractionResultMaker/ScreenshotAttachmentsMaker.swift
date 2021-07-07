import MixboxTestsFoundation

public protocol ScreenshotAttachmentsMaker: AnyObject {
    func makeScreenshotAttachments(
        beforeStep: Bool,
        includeHash: Bool)
        -> [Attachment]
}

public final class ScreenshotAttachmentsMakerImpl: ScreenshotAttachmentsMaker {
    private let imageHashCalculator: ImageHashCalculator
    private let deviceScreenshotTaker: DeviceScreenshotTaker
    
    public init(
        imageHashCalculator: ImageHashCalculator,
        deviceScreenshotTaker: DeviceScreenshotTaker)
    {
        self.imageHashCalculator = imageHashCalculator
        self.deviceScreenshotTaker = deviceScreenshotTaker
    }
    
    public func makeScreenshotAttachments(
        beforeStep: Bool,
        includeHash: Bool)
        -> [Attachment]
    {
        var attachments = [Attachment]()
        
        if let screenshot = try? deviceScreenshotTaker.takeDeviceScreenshot() {
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
                let screenshotHashAttachment: Attachment
                
                do {
                    let screenshotHash = try imageHashCalculator.imageHash(image: screenshot)
                    let screenshotHashString = String(describing: screenshotHash)
                    
                    screenshotHashAttachment = Attachment(
                        name: attachmentNameAndCircumstances(
                            attachmentName: "screenshot hash \(type(of: imageHashCalculator))",
                            beforeStep: beforeStep
                        ),
                        content: .text(screenshotHashString)
                    )
                } catch {
                    screenshotHashAttachment = Attachment(
                        name: attachmentNameAndCircumstances(
                            attachmentName: "screenshot hash failure",
                            beforeStep: beforeStep
                        ),
                        content: .text("Failed to get screenshot hash \(type(of: imageHashCalculator)): \(error)")
                    )
                }
                
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
