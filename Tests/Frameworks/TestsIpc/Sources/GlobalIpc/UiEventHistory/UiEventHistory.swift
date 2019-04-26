public final class UiEventHistory: Codable {
    public let uiEventHistoryRecords: [UiEventHistoryRecord]
    public let startDate: Date
    public let stopDate: Date
    
    public init(
        uiEventHistoryRecords: [UiEventHistoryRecord],
        startDate: Date,
        stopDate: Date)
    {
        self.uiEventHistoryRecords = uiEventHistoryRecords
        self.startDate = startDate
        self.stopDate = stopDate
    }
}
