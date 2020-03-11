import MixboxFoundation
import MixboxIoKit

public protocol MultiTouchEventFactory {
    func multiTouchEvent(dequeuedMultiTouchInfo: DequeuedMultiTouchInfo, time: AbsoluteTime) -> DigitizerEvent
}
