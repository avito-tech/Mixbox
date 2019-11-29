import UIKit
import TestsIpc
import MixboxFoundation

public final class UiEventHistoryTracker: UiEventObserver, UiEventHistoryProvider {
    private var uiEventHistoryRecords = [UiEventHistoryRecord]()
    
    // MARK: - UiEventHistoryProvider
    
    public func uiEventHistory(since startDate: Date) -> UiEventHistory {
        let currentDate = Date()
        
        return UiEventHistory(
            uiEventHistoryRecords: uiEventHistoryRecords.filter { $0.date >= startDate },
            startDate: startDate,
            stopDate: currentDate
        )
    }
    
    // MARK: - UiEventHistoryProvider
    
    public func eventWasSent(event: UIEvent) {
        do {
            let currentDate = Date()
            
            uiEventHistoryRecords.append(
                UiEventHistoryRecord(
                    event: try self.event(event: event),
                    date: currentDate
                )
            )
        } catch {
            // TODO: Assertion failure
        }
    }
    
    // MARK: - Private
    
    private func event(event: UIEvent) throws -> UiEvent {
        return UiEvent(
            type: try eventType(eventType: event.type),
            subtype: try eventSubtype(eventType: event.subtype),
            timestamp: event.timestamp,
            allTouches: try (event.allTouches ?? []).map(touch)
        )
    }
    
    private func touch(touch: UITouch) throws -> UiTouch {
        let preciseLocation: CGPoint
        
        if #available(iOS 9.1, *) {
            preciseLocation = touch.preciseLocation(in: nil)
        } else {
            preciseLocation = touch.location(in: nil) // TODO: Better fallback
        }
        
        return UiTouch(
            timestamp: touch.timestamp,
            phase: try phase(phase: touch.phase),
            tapCount: touch.tapCount,
            type: try touchType(touchType: touch.type),
            majorRadius: touch.majorRadius,
            majorRadiusTolerance: touch.majorRadiusTolerance,
            location: touch.location(in: nil),
            preciseLocation: preciseLocation
        )
    }
    
    private func touchType(touchType: UITouch.TouchType) throws -> UiTouch.TouchType {
        switch touchType {
        case .direct:
            return .direct
        case .indirect:
            return .indirect
        case .pencil:
            return .pencil
        @unknown default:
            throw UnsupportedEnumCaseError(touchType)
        }
    }
    
    private func phase(phase: UITouch.Phase) throws -> UiTouch.Phase {
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
        @unknown default:
            throw UnsupportedEnumCaseError(phase)
        }
    }
    
    private func eventType(eventType: UIEvent.EventType) throws -> UiEvent.EventType {
        switch eventType {
        case .touches:
            return .touches
        case .motion:
            return .motion
        case .remoteControl:
            return .remoteControl
        case .presses:
            return .presses
        @unknown default:
            throw UnsupportedEnumCaseError(eventType)
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func eventSubtype(eventType: UIEvent.EventSubtype) throws -> UiEvent.EventSubtype {
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
        @unknown default:
            throw UnsupportedEnumCaseError(eventType)
        }
    }
}
