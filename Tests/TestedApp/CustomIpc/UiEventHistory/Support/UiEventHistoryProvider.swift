import Foundation
import TestsIpc

public protocol UiEventHistoryProvider: class {
    func uiEventHistory(since startDate: Date) -> UiEventHistory
}
