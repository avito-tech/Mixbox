#if MIXBOX_ENABLE_IN_APP_SERVICES

// Mirrors UIEvent (incompletely)
public final class UiEvent: Codable {
    // Mirrors UIEvent.EventType (completely)
    public enum EventType: String, Codable {
        case touches
        case motion
        case remoteControl
        case presses
    }
    
    // Mirrors UIEvent.EventSubtype (completely)
    public enum EventSubtype: String, Codable {
        case none
        case motionShake
        case remoteControlPlay
        case remoteControlPause
        case remoteControlStop
        case remoteControlTogglePlayPause
        case remoteControlNextTrack
        case remoteControlPreviousTrack
        case remoteControlBeginSeekingBackward
        case remoteControlEndSeekingBackward
        case remoteControlBeginSeekingForward
        case remoteControlEndSeekingForward
    }
    
    public let type: EventType
    public let subtype: EventSubtype
    public let timestamp: TimeInterval
    public let allTouches: [UiTouch]
    
    public init(
        type: EventType,
        subtype: EventSubtype,
        timestamp: TimeInterval,
        allTouches: [UiTouch])
    {
        self.type = type
        self.subtype = subtype
        self.timestamp = timestamp
        self.allTouches = allTouches
    }
}

#endif
