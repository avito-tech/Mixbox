import MixboxFoundation
import MixboxIoKit

public protocol AggregatingTouchEventFactory {
    func aggregatingTouchEvent(
        dequeuedMultiTouchInfo: DequeuedMultiTouchInfo,
        time: AbsoluteTime)
        -> DigitizerEvent
}
