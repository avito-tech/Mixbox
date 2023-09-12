import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxInAppServices

public final class GrayApplicationQuiescenceWaiter: ApplicationQuiescenceWaiter {
    private let waiter: RunLoopSpinningWaiter
    private let idlingResource: IdlingResource
    private let waitingForQuiescenceTimeout: TimeInterval = 15 // TODO: Respect timeout settings of element
    private let waitingForQuiescencePollingInterval: TimeInterval = 0.1
    
    public init(
        waiter: RunLoopSpinningWaiter,
        idlingResource: IdlingResource
    ) {
        self.waiter = waiter
        self.idlingResource = idlingResource
    }
    
    public func waitForQuiescence() throws {
        let result = waiter.wait(
            timeout: waitingForQuiescenceTimeout,
            interval: waitingForQuiescencePollingInterval,
            until: { [idlingResource] in
                idlingResource.isIdle()
            }
        )
        
        switch result {
        case .stopConditionMet:
            return
        case .timedOut:
            throw ErrorString(
                """
                Failed to wait application for quiescence: timed out after \(waitingForQuiescenceTimeout) seconds.
                
                Waiting for quiescence is required to ensure that application is in a stable state (i.e. no animations are in progress, etc).
                
                This may happen if something is started, but not finished. This can either be a bug in application or bug in Mixbox.
                
                IdlingResource description:
                
                \(idlingResource.resourceDescription)
                """
            )
        }
    }
}
