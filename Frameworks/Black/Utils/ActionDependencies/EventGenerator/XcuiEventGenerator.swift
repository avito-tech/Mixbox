import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxFoundation
import Foundation
import UIKit
import MixboxBlack_objc
import MixboxTestsFoundation_objc

public final class XcuiEventGenerator: EventGenerator {
    private let applicationProvider: ApplicationProvider
    private let xcuiEventGeneratorObjC = EventGeneratorObjCProvider.eventGeneratorObjC()
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider = applicationProvider
    }
    
    public func pressAndDrag(
        from: CGPoint,
        to: CGPoint,
        durationOfInitialPress: TimeInterval,
        velocity: Double,
        cancelInertia: Bool)
    {
        xcuiEventGeneratorObjC.pressAndDrag(
            from: from,
            to: to,
            duration: durationOfInitialPress,
            velocity: velocity,
            cancelInertia: cancelInertia,
            application: applicationProvider.application
        )
    }
}
