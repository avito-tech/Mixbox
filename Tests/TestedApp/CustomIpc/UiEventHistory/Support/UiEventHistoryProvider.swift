import Foundation
import TestsIpc

protocol UiEventHistoryProvider {
    func uiEventHistory(since startDate: Date) -> UiEventHistory
}
