public protocol RecordedCallsProvider: AnyObject {
    var recordedCalls: [RecordedCall] { get }
}
