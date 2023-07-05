enum AccessibilityStatus {
    case full
    case basic
    case unknown
}

import Foundation
import TestsIpc

class BaseTestabilityTestCase: TestCase {
    var accessibilityStatus: AccessibilityStatus {
        switch testType {
        case .whiteBox:
            return .basic
        case .grayBox:
            return ProcessInfo.processInfo.isRunningFromXcode ? .full : .unknown
        case .blackBox:
            return .full
        }
    }
}
