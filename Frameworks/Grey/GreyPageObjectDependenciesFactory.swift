import MixboxUiTestsFoundation

public final class GreyPageObjectDependenciesFactory: PageObjectDependenciesFactory {
    /*
     These dependencies might be a good start:
     
     interactionExecutionLogger
     testFailureRecorder
     ipcClient
     snapshotsComparisonUtility
     stepLogger
     pollingConfiguration
     elementFinder
     */
    public init() {
    }
    
    public func pageObjectElementFactory() -> PageObjectElementFactory {
        preconditionFailure("Not implemented")
    }
}
