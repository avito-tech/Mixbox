import MixboxFoundation
import UIKit

public final class InteractionSettings {
    public let name: String
    public let matcher: ElementMatcher
    public let functionDeclarationLocation: FunctionDeclarationLocation
    public let scrollMode: ScrollMode
    public let interactionTimeout: TimeInterval
    public let interactionMode: InteractionMode
    public let percentageOfVisibleArea: CGFloat
    public let pixelPerfectVisibilityCheck: Bool
    
    public init(
        name: String,
        matcher: ElementMatcher,
        functionDeclarationLocation: FunctionDeclarationLocation,
        scrollMode: ScrollMode,
        interactionTimeout: TimeInterval,
        interactionMode: InteractionMode,
        percentageOfVisibleArea: CGFloat,
        pixelPerfectVisibilityCheck: Bool)
    {
        self.name = name
        self.matcher = matcher
        self.functionDeclarationLocation = functionDeclarationLocation
        self.scrollMode = scrollMode
        self.interactionTimeout = interactionTimeout
        self.interactionMode = interactionMode
        self.percentageOfVisibleArea = percentageOfVisibleArea
        self.pixelPerfectVisibilityCheck = pixelPerfectVisibilityCheck
    }
}
