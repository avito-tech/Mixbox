#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation
import MixboxIpcCommon

public protocol UiEventHistoryProvider: AnyObject {
    func uiEventHistory(since startDate: Date) -> UiEventHistory
}

#endif
