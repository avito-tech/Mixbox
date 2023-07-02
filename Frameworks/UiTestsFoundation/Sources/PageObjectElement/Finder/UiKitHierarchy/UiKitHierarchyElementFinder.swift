import MixboxFoundation
import MixboxTestsFoundation
import MixboxIpc
import MixboxIpcCommon

public final class UiKitHierarchyElementFinder: ElementFinder {
    private let viewHierarchyProvider: ViewHierarchyProvider
    private let testFailureRecorder: TestFailureRecorder
    private let stepLogger: StepLogger
    private let applicationScreenshotTaker: ApplicationScreenshotTaker
    private let performanceLogger: PerformanceLogger
    private let dateProvider: DateProvider
    
    public init(
        viewHierarchyProvider: ViewHierarchyProvider,
        testFailureRecorder: TestFailureRecorder,
        stepLogger: StepLogger,
        applicationScreenshotTaker: ApplicationScreenshotTaker,
        performanceLogger: PerformanceLogger,
        dateProvider: DateProvider
    ) {
        self.viewHierarchyProvider = viewHierarchyProvider
        self.testFailureRecorder = testFailureRecorder
        self.stepLogger = stepLogger
        self.applicationScreenshotTaker = applicationScreenshotTaker
        self.performanceLogger = performanceLogger
        self.dateProvider = dateProvider
    }
    
    public func query(
        elementMatcher: ElementMatcher,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation)
        -> ElementQuery
    {
        return UiKitHierarchyElementQuery(
            viewHierarchyProvider: viewHierarchyProvider,
            elementMatcher: elementMatcher,
            testFailureRecorder: testFailureRecorder,
            stepLogger: stepLogger,
            applicationScreenshotTaker: applicationScreenshotTaker,
            performanceLogger: performanceLogger,
            dateProvider: dateProvider,
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
        )
    }
}
