import UIKit
import TestsIpc

final class UiEventHistoryTracker: UiEventObserver, UiEventHistoryProvider {
    private var uiEventHistoryRecords = [UiEventHistoryRecord]()
    
    // MARK: - UiEventHistoryProvider
    
    func uiEventHistory(since startDate: Date) -> UiEventHistory {
        let currentDate = Date()
        
        return UiEventHistory(
            uiEventHistoryRecords: uiEventHistoryRecords.filter { $0.date >= startDate },
            startDate: startDate,
            stopDate: currentDate
        )
    }
    
    // MARK: - UiEventHistoryProvider
    
    func eventWasSent(event: UIEvent) {
        let currentDate = Date()
        
        uiEventHistoryRecords.append(
            UiEventHistoryRecord(
                event: self.event(event: event),
                date: currentDate
            )
        )
    }
    
    // MARK: - Private
    
    private func event(event: UIEvent) -> UiEvent {
        return UiEvent(
            type: eventType(eventType: event.type),
            subtype: eventSubtype(eventType: event.subtype),
            timestamp: event.timestamp,
            allTouches: (event.allTouches ?? []).map(touch)
        )
    }
    
    private func touch(touch: UITouch) -> UiTouch {
        let preciseLocation: CGPoint
        
        if #available(iOS 9.1, *) {
            preciseLocation = touch.preciseLocation(in: nil)
        } else {
            preciseLocation = touch.location(in: nil) // TODO: Better fallback
        }
        
        return UiTouch(
            timestamp: touch.timestamp,
            phase: phase(phase: touch.phase),
            tapCount: touch.tapCount,
            type: touchType(touchType: touch.type),
            majorRadius: touch.majorRadius,
            majorRadiusTolerance: touch.majorRadiusTolerance,
            location: touch.location(in: nil),
            preciseLocation: preciseLocation
        )
    }
    
    private func touchType(touchType: UITouch.TouchType) -> UiTouch.TouchType {
        switch touchType {
        case .direct:
            return .direct
        case .indirect:
            return .indirect
        case .pencil:
            return .pencil
        }
    }
    
    private func phase(phase: UITouch.Phase) -> UiTouch.Phase {
        switch phase {
        case .began:
            return .began
        case .moved:
            return .moved
        case .stationary:
            return .stationary
        case .ended:
            return .ended
        case .cancelled:
            return .cancelled
        }
    }
    
    private func eventType(eventType: UIEvent.EventType) -> UiEvent.EventType {
        switch eventType {
        case .touches:
            return .touches
        case .motion:
            return .motion
        case .remoteControl:
            return .remoteControl
        case .presses:
            return .presses
        }
    }
    
    private func eventSubtype(eventType: UIEvent.EventSubtype) -> UiEvent.EventSubtype {
        switch eventType {
        case .none:
            return .none
        case .motionShake:
            return .motionShake
        case .remoteControlPlay:
            return .remoteControlPlay
        case .remoteControlPause:
            return .remoteControlPause
        case .remoteControlStop:
            return .remoteControlStop
        case .remoteControlTogglePlayPause:
            return .remoteControlTogglePlayPause
        case .remoteControlNextTrack:
            return .remoteControlNextTrack
        case .remoteControlPreviousTrack:
            return .remoteControlPreviousTrack
        case .remoteControlBeginSeekingBackward:
            return .remoteControlBeginSeekingBackward
        case .remoteControlEndSeekingBackward:
            return .remoteControlEndSeekingBackward
        case .remoteControlBeginSeekingForward:
            return .remoteControlBeginSeekingForward
        case .remoteControlEndSeekingForward:
            return .remoteControlEndSeekingForward
        }
    }
}
