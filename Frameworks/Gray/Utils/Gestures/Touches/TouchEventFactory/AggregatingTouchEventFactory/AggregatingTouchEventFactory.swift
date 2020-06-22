import MixboxFoundation
import MixboxIoKit
import UIKit
import Foundation

public protocol AggregatingTouchEventFactory {
    func aggregatingTouchEvent(
        dequeuedMultiTouchInfo: DequeuedMultiTouchInfo,
        time: AbsoluteTime)
        -> DigitizerEvent
}
