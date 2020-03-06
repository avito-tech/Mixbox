import MixboxFoundation
import MixboxIoKit

public protocol FingerTouchEventFactory {
    func fingerEvents(
        dequeuedMultiTouchInfo: DequeuedMultiTouchInfo,
        time: AbsoluteTime)
        -> [DigitizerFingerEvent]
}
