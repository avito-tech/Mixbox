#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import UIKit

public final class InteractionCoordinates: Codable {
    //  If point is not specified it will be a center (for all cases).
    public enum Mode: String, Codable {
        // Interaction will adjust coordinates to a visible point closest to a given point.
        case useClosestVisiblePoint
        // Interaction will ignore visibility of the point.
        case useSpecifiedPoint
    }
    
    // Examples:
    // - Pass nil for center
    // - Pass (0, 1) for left top point.
    // - Pass (0.5, 0) for middle bottom point.
    public let normalizedCoordinate: CGPoint?
    
    // Absolute offset is added to an offest
    // calculated with `normalizedCoordinate`
    public let absoluteOffset: CGVector?
    
    // Pass mode to override default mode.
    // - If coordinates are given then default mode is `useSpecifiedPoint`
    // - If coordinates are nil then default mode is `useClosestVisiblePoint`
    //   and the point is in center of the view.
    public let mode: Mode?
    
    // Default: use visible point closest to center
    public static let `default` = InteractionCoordinates(
        normalizedCoordinate: nil,
        absoluteOffset: nil,
        mode: nil
    )
    
    public init(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        mode: Mode? = nil)
    {
        self.normalizedCoordinate = normalizedCoordinate
        self.absoluteOffset = absoluteOffset
        self.mode = mode
    }
    
    public func resolveMode() -> Mode {
        if normalizedCoordinate == nil && absoluteOffset == nil {
            return .useClosestVisiblePoint
        } else {
            return .useSpecifiedPoint
        }
    }
    
    public func interactionCoordinatesOnScreen(elementFrameRelativeToScreen: CGRect) -> CGPoint {
        var coordinate = CGPoint(
            x: elementFrameRelativeToScreen.midX,
            y: elementFrameRelativeToScreen.midY
        ) 

        if let normalizedCoordinate = normalizedCoordinate {
            coordinate.x += elementFrameRelativeToScreen.width * (normalizedCoordinate.x - 0.5)
            coordinate.y += elementFrameRelativeToScreen.height * (normalizedCoordinate.y - 0.5)
        }

        if let absoluteOffset = absoluteOffset {
            coordinate.x += absoluteOffset.dx
            coordinate.y += absoluteOffset.dy
        }

        return coordinate
    }
}

#endif
