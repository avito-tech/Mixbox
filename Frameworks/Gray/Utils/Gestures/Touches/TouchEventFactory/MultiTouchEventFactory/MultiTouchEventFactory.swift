import MixboxFoundation
import MixboxIoKit
import UIKit
import Foundation

public protocol MultiTouchEventFactory {
    func multiTouchEvent(dequeuedMultiTouchInfo: DequeuedMultiTouchInfo, time: AbsoluteTime) -> DigitizerEvent
}
