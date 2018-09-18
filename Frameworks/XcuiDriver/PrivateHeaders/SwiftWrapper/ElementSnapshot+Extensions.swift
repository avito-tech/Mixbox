import MixboxIpcCommon
import MixboxIpcClients
import MixboxIpc
import MixboxUiKit
import MixboxUiTestsFoundation
import XCTest

extension ElementSnapshot {
    public func percentageOfVisibleArea(ipcClient: IpcClient) -> CGFloat? {
        guard let uniqueIdentifier = uniqueIdentifier.value else {
            return nil
        }
        
        let result = ipcClient.call(
            method: PercentageOfVisibleAreaIpcMethod(),
            arguments: uniqueIdentifier
        )
        
        // TODO: Replace nil with 0 in PercentageOfVisibleAreaIpcMethodHandler?
        return (result.data ?? .none) ?? 0
    }
    
    public func hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus() -> Bool {
        if hasKeyboardFocus {
            return true
        }
        for child in children {
            if child.hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus() {
                return true
            }
        }
        return false
    }
    
    public func image() -> UIImage? {
        // TODO: Remove singletons
        let image = XCUIApplication().screenshot().image
        
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let frameForCropping = CGRect(
            x: frameOnScreen.origin.x * image.scale,
            y: frameOnScreen.origin.y * image.scale,
            width: frameOnScreen.size.width * image.scale,
            height: frameOnScreen.size.height * image.scale
        )
        
        guard let croppedCgImage = cgImage.cropping(to: frameForCropping) else {
            return nil
        }
        
        let croppedImage = UIImage(cgImage: croppedCgImage, scale: image.scale, orientation: image.imageOrientation)
        
        return croppedImage
    }
    
    func swipe(direction: SwipeDirection) {
        let swipeLength: CGFloat = 100
        let delta = normalizedOffsetForSwipe(direction: direction) * swipeLength
        let origin = frameOnScreen.mb_center
        
        EventGenerator.instance.swipe(from: origin, to: origin + delta)
    }
    
    private func normalizedOffsetForSwipe(direction: SwipeDirection) -> CGVector {
        let dxNormalized: CGFloat
        let dyNormalized: CGFloat
        
        switch direction {
        case .up:
            dxNormalized = 0
            dyNormalized = -1
        case .down:
            dxNormalized = 0
            dyNormalized = 1
        case .left:
            dxNormalized = -1
            dyNormalized = 0
        case .right:
            dxNormalized = 1
            dyNormalized = 0
        }
        
        return CGVector(
            dx: dxNormalized,
            dy: dyNormalized
        )
    }
}
