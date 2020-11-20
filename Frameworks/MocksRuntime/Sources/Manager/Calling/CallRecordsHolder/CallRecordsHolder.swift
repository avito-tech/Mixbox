public protocol CallRecordsHolder: CallRecordsProvider {
    var callRecords: [CallRecord] { get set }
}
