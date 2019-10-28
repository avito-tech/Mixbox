import MixboxTestsFoundation
import MixboxFoundation

public final class InteractionResultMakerImpl: InteractionResultMaker {
    private let elementHierarchyDescriptionProvider: ElementHierarchyDescriptionProvider
    private let screenshotTaker: ScreenshotTaker
    private let extendedStackTraceProvider: ExtendedStackTraceProvider
    private let fileLine: FileLine
    
    public init(
        elementHierarchyDescriptionProvider: ElementHierarchyDescriptionProvider,
        screenshotTaker: ScreenshotTaker,
        extendedStackTraceProvider: ExtendedStackTraceProvider,
        fileLine: FileLine)
    {
        self.elementHierarchyDescriptionProvider = elementHierarchyDescriptionProvider
        self.screenshotTaker = screenshotTaker
        self.extendedStackTraceProvider = extendedStackTraceProvider
        self.fileLine = fileLine
    }
    
    public func decorateFailure(
        interactionFailure: InteractionFailure)
        -> InteractionResult
    {
        let failure = InteractionFailure(
            message: interactionFailure.message,
            attachments: interactionFailure.attachments + attachments(message: interactionFailure.message),
            nestedFailures: interactionFailure.nestedFailures
        )
        
        return .failure(failure)
    }
    
    private func attachments(message: String) -> [Attachment] {
        var attachments = [Attachment]()
        
        attachments.append(contentsOf: hierarchyAttachments())
        attachments.append(contentsOf: stackTraceAttachments())
        attachments.append(contentsOf: errorMessageAttachments(message: message))
        
        return attachments
    }
    
    private func stackTraceAttachments() -> [Attachment] {
        // TODO: Restore this attachment after fixing duplication of attachments
        return []
        
        // TODO: Share code! Exctract to class.
        // Should look like: "2   xctest                              0x000000010e7a0069 main + 0"
        
        let string = extendedStackTraceProvider
            .extendedStackTrace()
            .enumerated()
            .map { indexed in
                if let file = indexed.element.file, let line = indexed.element.line {
                    return "\(indexed.offset) \(file):\(line)"
                } else {
                    return "\(indexed.offset) \(indexed.element.symbol ?? "???") \(indexed.element.address)"
                }
            }
            .joined(separator: "\n")
        
        return [
            Attachment(
                name: "Stack trace",
                content: .text(string)
            )
        ]
    }
    
    private func hierarchyAttachments() -> [Attachment] {
        // TODO: Restore this attachment after fixing duplication of attachments
        return []
        
        guard let string = elementHierarchyDescriptionProvider.elementHierarchyDescription() else {
            return []
        }
        
        return [
            Attachment(
                name: "Element hierarchy",
                content: .text(string)
            )
        ]
    }
    
    private func errorMessageAttachments(message: String) -> [Attachment] {
        // TODO: Restore this attachment after fixing duplication of attachments
        return []
        
        return [
            Attachment(
                name: "Error description",
                content: .text("\(fileLine.file):\(fileLine.line): \(message))")
            )
        ]
    }
    
}
