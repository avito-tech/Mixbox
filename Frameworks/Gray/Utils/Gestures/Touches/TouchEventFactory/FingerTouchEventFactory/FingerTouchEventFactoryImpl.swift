import MixboxFoundation
import MixboxIoKit

public final class FingerTouchEventFactoryImpl: FingerTouchEventFactory {
    public func fingerEvents(
        dequeuedMultiTouchInfo: DequeuedMultiTouchInfo,
        time: AbsoluteTime)
        -> [DigitizerFingerEvent]
    {
        return dequeuedMultiTouchInfo.touchesByFinger.enumerated().map { (arg) -> DigitizerFingerEvent in
            let (fingerIndex, touchInfo) = arg
            
            return DigitizerFingerEvent(
                allocator: kCFAllocatorDefault,
                timeStamp: time,
                index: 0,
                identifier: UInt32(fingerIndex), // TODO: Throw error for conversion error?
                eventMask: eventMask(touchInfo: touchInfo),
                x: IOHIDFloat(touchInfo.point.x),
                y: IOHIDFloat(touchInfo.point.y),
                z: 0,
                tipPressure: 0,
                twist: 0,
                range: range(touchInfo: touchInfo),
                touch: touch(touchInfo: touchInfo),
                options: []
            )
        }
    }
    
    // Both range and touch are set to 0 if phase is UITouchPhaseEnded, 1 otherwise.
    private func range(touchInfo: DequeuedMultiTouchInfo.TouchInfo) -> Bool {
        return touchInfo.phase != .ended
    }
    
    private func touch(touchInfo: DequeuedMultiTouchInfo.TouchInfo) -> Bool {
        return touchInfo.phase != .ended
    }
    
    private func eventMask(touchInfo: DequeuedMultiTouchInfo.TouchInfo) -> IOHIDDigitizerEventMask {
        var eventMask = IOHIDDigitizerEventMask()
        
        switch touchInfo.phase {
        case .cancelled, .began, .ended, .stationary:
            eventMask.update(with: .position)
        case .moved:
            break
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
