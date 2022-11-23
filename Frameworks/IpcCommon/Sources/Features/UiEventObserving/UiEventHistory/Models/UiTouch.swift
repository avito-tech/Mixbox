#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import UIKit

// Mirrors UIKit.UITouch (incompletely)
public final class UiTouch: Codable {
    // Mirrors UITouch.Phase (completely)
    public enum Phase: String, Codable {
        case began
        case moved
        case stationary
        case ended
        case cancelled
        case regionEntered
        case regionExited
        case regionMoved
    }
    
    // Mirrors UITouch.TouchType (completely)
    public enum TouchType: String, Codable {
        case direct
        case indirect
        case pencil
        case indirectPointer
        case stylus
    }
    
    public let timestamp: TimeInterval
    public let phase: Phase
    public let tapCount: Int
    public let type: TouchType
    public let majorRadius: CGFloat
    public let majorRadiusTolerance: CGFloat
    public let location: CGPoint
    public let preciseLocation: CGPoint
    
    public init(
        timestamp: TimeInterval,
        phase: Phase,
        tapCount: Int,
        type: TouchType,
        majorRadius: CGFloat,
        majorRadiusTolerance: CGFloat,
        location: CGPoint,
        preciseLocation: CGPoint)
    {
        self.timestamp = timestamp
        self.phase = phase
        self.tapCount = tapCount
        self.type = type
        self.majorRadius = majorRadius
        self.majorRadiusTolerance = majorRadiusTolerance
        self.location = location
        self.preciseLocation = preciseLocation
    }
}

#endif
