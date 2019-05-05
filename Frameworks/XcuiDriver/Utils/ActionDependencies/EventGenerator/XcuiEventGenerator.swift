import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxFoundation

public final class XcuiEventGenerator: EventGenerator {
    private let applicationProvider: ApplicationProvider
    private let xcuiEventGeneratorObjC = EventGeneratorObjCProvider.eventGeneratorObjC()
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider
            = applicationProvider
    }
    
    public func pressAndDrag(from: CGPoint, to: CGPoint, duration: TimeInterval, velocity: Double) {
        xcuiEventGeneratorObjC.pressAndDrag(
            from: from,
            to: to,
            duration: duration,
            velocity: velocity,
            application: applicationProvider.application
        )
    }
}
