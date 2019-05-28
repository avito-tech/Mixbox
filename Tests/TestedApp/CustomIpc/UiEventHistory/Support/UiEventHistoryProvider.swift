import Foundation
import TestsIpc

public protocol UiEventHistoryProvider {
    func uiEventHistory(since startDate: Date) -> UiEventHistory
}
