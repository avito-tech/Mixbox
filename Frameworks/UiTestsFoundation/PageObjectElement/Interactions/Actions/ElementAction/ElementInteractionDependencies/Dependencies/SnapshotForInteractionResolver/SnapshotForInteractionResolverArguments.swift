import MixboxIpcCommon

public final class SnapshotForInteractionResolverArguments {
    public let overridenPercentageOfVisibleArea: CGFloat?
    public let interactionCoordinates: InteractionCoordinates?
    
    public init(
        overridenPercentageOfVisibleArea: CGFloat?,
        interactionCoordinates: InteractionCoordinates?)
    {
        self.overridenPercentageOfVisibleArea = overridenPercentageOfVisibleArea
        self.interactionCoordinates = interactionCoordinates
    }
}
