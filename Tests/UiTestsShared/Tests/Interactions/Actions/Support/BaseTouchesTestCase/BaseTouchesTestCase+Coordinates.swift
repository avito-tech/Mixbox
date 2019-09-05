import TestsIpc
import MixboxFoundation

extension BaseTouchesTestCase {
    var relativeCoordinatesAccuracy: CGFloat {
        return 0.5
    }
    
    // We can afford checking hardcoded coordinates, because frames are fixed in the view (and they are required to be so).
    var absoluteCoordinatesAccuracy: CGFloat {
        return 1
    }
    
    // Ensure to view with your eyes that "target view" (small blue view) is tapped before changing values in test.
    var targetViewCenter: CGPoint {
        return CGPoint(
            x: 106.33332824707031,
            y: 130.0
        )
    }
    
    func targetViewFrame() throws -> CGRect {
        guard let frame = (screen.targetView.value(valueTitle: "frameRelativeToScreen") { $0.frameRelativeToScreen }) else {
            throw ErrorString("Failed to get frameRelativeToScreen of targetView")
        }
        
        return frame
    }
    
    func targetViewFrameCenter() throws -> CGPoint {
        return try targetViewFrame().mb_center
    }
    
    func targetViewFrameCenterToWindow() throws -> CGPoint {
        return screen.targetView.centerToWindow.unwrapOrFail()
    }
}
