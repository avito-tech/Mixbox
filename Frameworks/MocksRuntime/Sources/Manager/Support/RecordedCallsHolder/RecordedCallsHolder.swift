public protocol RecordedCallsHolder: RecordedCallsProvider {
    var recordedCalls: [RecordedCall] { get set }
}
