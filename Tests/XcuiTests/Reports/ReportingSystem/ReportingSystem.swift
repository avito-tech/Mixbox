// Thread safe. Reports can be added from multiple threads.
// Completion can be called on any thread.
//
// TODO: Add setUp method? E.g.: to clear some state.
public protocol ReportingSystem: class {
    func reportTestCase(
        testCaseReport: TestCaseReport,
        completion: @escaping () -> ())
}

// To not send reports, can be stored in non-optional ReportingSystem.
public final class DevNullReportingSystem: ReportingSystem {
    public init() {
    }
    
    public func reportTestCase(
        testCaseReport: TestCaseReport,
        completion: @escaping () -> ())
    {
        completion()
    }
}
