public final class AlwaysFailingNotificationsApplicationPermissionSetterFactory:
    NotificationsApplicationPermissionSetterFactory
{
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        testFailureRecorder: TestFailureRecorder)
    {
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func notificationsApplicationPermissionSetter(
        bundleId: String,
        displayName: String)
        -> ApplicationPermissionWithoutNotDeterminedStateSetter
    {
        return AlwaysFailingApplicationPermissionWithoutNotDeterminedStateSetter(
            testFailureRecorder: testFailureRecorder
        )
    }
}
