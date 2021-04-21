import MixboxFoundation
import CoreGraphics

public final class ElementFactoryElementSettings {
    public var scrollMode: CustomizableScalar<ScrollMode>
    public var interactionTimeout: CustomizableScalar<TimeInterval>
    public var interactionMode: CustomizableScalar<InteractionMode>
    public var percentageOfVisibleArea: CustomizableScalar<CGFloat>
    public var pixelPerfectVisibilityCheck: CustomizableScalar<Bool>
    
    public init(
        scrollMode: CustomizableScalar<ScrollMode>,
        interactionTimeout: CustomizableScalar<TimeInterval>,
        interactionMode: CustomizableScalar<InteractionMode>,
        percentageOfVisibleArea: CustomizableScalar<CGFloat>,
        pixelPerfectVisibilityCheck: CustomizableScalar<Bool>)
    {
        self.scrollMode = scrollMode
        self.interactionTimeout = interactionTimeout
        self.interactionMode = interactionMode
        self.percentageOfVisibleArea = percentageOfVisibleArea
        self.pixelPerfectVisibilityCheck = pixelPerfectVisibilityCheck
    }
}
