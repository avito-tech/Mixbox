import MixboxArtifacts

public protocol ScreenshotAttachmentsMaker: class {
    func makeScreenshotArtifacts(
        beforeStep: Bool,
        includeHash: Bool)
        -> [Artifact]
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
    
    public func makeScreenshotArtifacts(
        beforeStep: Bool,
        includeHash: Bool)
        -> [Artifact]
    {
        var artifacts = [Artifact]()
        
        if let screenshot = screenshotTaker.takeScreenshot() {
            let screenshotArtifact = Artifact(
                name: artifactNameAndCircumstances(
                    artifactName: "Скриншот",
                    beforeStep: beforeStep
                ),
                content: .screenshot(screenshot)
            )
            
            artifacts.append(screenshotArtifact)
            
            // Simplifies error classification
            if includeHash {
                let screenshotHash = imageHashCalculator.imageHash(image: screenshot)
                let screenshotHashArtifact = Artifact(
                    name: artifactNameAndCircumstances(
                        artifactName: "hash скриншота \(type(of: imageHashCalculator))",
                        beforeStep: beforeStep
                    ),
                    content: .text("\(screenshotHash)")
                )
                artifacts.append(screenshotHashArtifact)
            }
        }
        
        return artifacts
    }
    
    private func artifactNameAndCircumstances(
        artifactName: String,
        beforeStep: Bool)
        -> String
    {
        let interactionTime = beforeStep ? "до" : "после"
        
        return "\(artifactName) \(interactionTime)"
    }
}
