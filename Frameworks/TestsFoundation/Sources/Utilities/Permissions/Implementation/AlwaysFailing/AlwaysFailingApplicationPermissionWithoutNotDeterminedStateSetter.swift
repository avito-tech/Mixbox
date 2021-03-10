import MixboxFoundation

public final class AlwaysFailingApplicationPermissionWithoutNotDeterminedStateSetter:
    ApplicationPermissionWithoutNotDeterminedStateSetter
{
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        testFailureRecorder: TestFailureRecorder)
    {
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func set(_ state: AllowedDeniedState) {
        testFailureRecorder.recordFailure(
            description: "Setting this state is not implemented",
            shouldContinueTest: false
        )
    }
}
