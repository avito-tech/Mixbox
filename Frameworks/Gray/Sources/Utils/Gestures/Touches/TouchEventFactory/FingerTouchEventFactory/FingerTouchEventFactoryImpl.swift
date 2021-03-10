import MixboxFoundation
import MixboxIoKit

public final class FingerTouchEventFactoryImpl: FingerTouchEventFactory {
    public init() {
    }
    
    public func fingerEvents(
        dequeuedMultiTouchInfo: DequeuedMultiTouchInfo,
        time: AbsoluteTime)
        -> [DigitizerFingerEvent]
    {
        return dequeuedMultiTouchInfo.touchesByFinger.enumerated().map { (arg) -> DigitizerFingerEvent in
            let (fingerIndex, touchInfo) = arg
            let identifiyOffset: UInt32 = 2 // I don't know the logic of how simulator injects events. See `MultiTouchEventFactoryTests`.
            
            let event = DigitizerFingerEvent(
                allocator: kCFAllocatorDefault,
                timeStamp: time,
                index: 0,
                identity: identifiyOffset + UInt32(fingerIndex), // TODO: Throw error for conversion error?
                eventMask: eventMask(touchInfo: touchInfo),
                x: Double(touchInfo.point.x),
                y: Double(touchInfo.point.y),
                z: 0,
                tipPressure: 0,
                twist: 90, // I have no idea why. See `MultiTouchEventFactoryTests`. Maybe it will work incorrectly after screen rotation.
                range: range(touchInfo: touchInfo),
                touch: touch(touchInfo: touchInfo),
                options: [.isAbsolute]
            )
            
            // See `MultiTouchEventFactoryTests`
            event.isDisplayIntegrated = true
            event.quality = 1.5
            event.density = 1.5
            event.irregularity = 0
            event.majorRadius = 4.599991
            event.minorRadius = 3.799988
            
            return event
        }
    }
    
    // Both range and touch are set to 0 if phase is UITouchPhaseEnded, 1 otherwise.
    private func range(touchInfo: DequeuedMultiTouchInfo.TouchInfo) -> Bool {
        return touchInfo.phase != .ended
    }
    
    private func touch(touchInfo: DequeuedMultiTouchInfo.TouchInfo) -> Bool {
        return touchInfo.phase != .ended
    }
    
    private func eventMask(touchInfo: DequeuedMultiTouchInfo.TouchInfo) -> DigitizerEventMask {
        var eventMask = DigitizerEventMask()
        
        switch touchInfo.phase {
        case .cancelled, .began, .ended, .stationary:
            break
        case .moved:
            eventMask.update(with: .position)
        }
        
        switch touchInfo.phase {
        case .began, .ended, .cancelled:
            eventMask.update(with: .touch)
            eventMask.update(with: .range)
        case .stationary, .moved:
            break
        }
        
        switch touchInfo.phase {
        case .cancelled:
            eventMask.update(with: .cancel)
        case .began, .ended, .stationary, .moved:
            break
        }
        
        if touchInfo.pressure != nil {
            eventMask.update(with: .attribute)
        }
        
        return eventMask
    }
}
