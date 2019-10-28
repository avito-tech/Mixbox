import MixboxFoundation
import MixboxUiTestsFoundation

public final class XcuiElementSimpleGesturesProvider: ElementSimpleGesturesProvider {
    private let applicationProvider: ApplicationProvider
    private let applicationFrameProvider: ApplicationFrameProvider
    private let applicationCoordinatesProvider: ApplicationCoordinatesProvider
    
    public init(
        applicationProvider: ApplicationProvider,
        applicationFrameProvider: ApplicationFrameProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider)
    {
        self.applicationProvider = applicationProvider
        self.applicationFrameProvider = applicationFrameProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
    }
    
    public func elementSimpleGestures(
        elementSnapshot: ElementSnapshot,
        interactionCoordinates: InteractionCoordinates)
        throws
        -> ElementSimpleGestures
    {
        var tapCoordinate = interactionCoordinates.interactionCoordinatesOnScreen(elementSnapshot: elementSnapshot)
        
        // Kludge to fix tapping on "com.apple.springboard"'s alerts.
        // They can not be tapped by coordinate (even with private XCEventGenerator).
        // If there is an alert every tap by coordinate results in alert being dismissed.
        // If you want to tap "Proceed"/"OK" button it will tap "Cancel" button.
        // However, it is possible to interact with XCUIElement inside the alert.
        // We don't want to use XCUIElement for interacting with an element,
        // because it will require to remove abstraction of interfaces
        // that are designed to work with black-box and gray-box testing.
        //
        // But we can find an alert and tap the coordinate relative to it.
        //
        // Note: every action is working this way.
        //
        let uiInterruptionStatus = self.uiInterruptionStatus(snapshot: elementSnapshot)
        
        if uiInterruptionStatus.actionWouldNotWorkDueToUiInterruptionHandling {
            // WARNING: It may use other alert! There may be bugs. Ideally we should find same alert.
            let alert = applicationProvider.application.alerts.element(boundBy: 0)
            
            let alertFrame = alert.frame
            
            if alertFrame.contains(tapCoordinate) {
                let applicationFrame = applicationFrameProvider.applicationFrame
                
                tapCoordinate.x -= alertFrame.origin.x - applicationFrame.origin.x
                tapCoordinate.y -= alertFrame.origin.y - applicationFrame.origin.y
                
                let xcuiCoordinate = alert
                    .coordinate(withNormalizedOffset: CGVector.zero)
                    .withOffset(CGVector(dx: tapCoordinate.x, dy: tapCoordinate.y))
                
                return XcuiCoordinateElementSimpleGestures(
                    xcuiCoordinate: xcuiCoordinate
                )
            } else {
                throw ErrorString("Can not reliably tap system alert by coordinate."
                    + " Try to use pure XCUI functions or use addUIInterruptionMonitor function of XCTestCase")
            }
        } else {
            return XcuiCoordinateElementSimpleGestures(
                xcuiCoordinate: applicationCoordinatesProvider.tappableCoordinate(point: tapCoordinate)
            )
        }
    }
    
    // Workaround. See usage for more comments.
    private struct UiInterruptionStatus {
        var actionWouldNotWorkDueToUiInterruptionHandling: Bool {
            return interruptingAlert != nil
        }
        
        // Now only alerts treated as interruptions. Maybe we can reverse engineer XCTest and find
        // the exact algorithm, and maybe we can make more reliable workaround after reverse engineering.
        let interruptingAlert: ElementSnapshot?
    }
    
    private func uiInterruptionStatus(snapshot: ElementSnapshot) -> UiInterruptionStatus {
        var pointer: ElementSnapshot? = snapshot
        while let snapshot = pointer, snapshot.elementType != .alert {
            pointer = snapshot.parent
        }
        
        // Maybe just a comparison of "com.apple.springboard" will work.
        if let snapshot = pointer, snapshot.elementType == .alert && applicationProvider.application.bundleID.starts(with: "com.apple.") {
            return UiInterruptionStatus(interruptingAlert: snapshot)
        } else {
            return UiInterruptionStatus(interruptingAlert: nil)
        }
    }
}
