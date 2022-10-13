import MixboxTestsFoundation
import MixboxFoundation

public final class ResolvedElementQueryLoggerImpl: ResolvedElementQueryLogger {
    private let stepLogger: StepLogger
    private let dateProvider: DateProvider
    private let applicationScreenshotTaker: ApplicationScreenshotTaker
    private let performanceLogger: PerformanceLogger
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        stepLogger: StepLogger,
        dateProvider: DateProvider,
        applicationScreenshotTaker: ApplicationScreenshotTaker,
        performanceLogger: PerformanceLogger,
        testFailureRecorder: TestFailureRecorder
    ) {
        self.stepLogger = stepLogger
        self.dateProvider = dateProvider
        self.applicationScreenshotTaker = applicationScreenshotTaker
        self.performanceLogger = performanceLogger
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func logResolvingElement(
        resolveElement: () -> ResolvedElementQueryLoggerResolvingInfo,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation
    ) -> ResolvedElementQuery {
        return performanceLogger.logSignpost(staticName: "RVHEQ resolveElement") { () -> ResolvedElementQuery in
            let stepLogBefore = StepLogBefore(
                date: dateProvider.currentDate(),
                title: "Поиск элемента"
            )
            
            let wrapper = stepLogger.logStep(stepLogBefore: stepLogBefore) { () -> StepLoggerResultWrapper<ResolvedElementQuery> in
                return performanceLogger.logSignpost(staticName: "RVHEQ log to StepLogger") { () -> StepLoggerResultWrapper<ResolvedElementQuery> in
                    let info = performanceLogger.logSignpost(staticName: "RVHEQ resolveElementQuery") {
                        resolveElement()
                    }
                    
                    switch info.status {
                    case let .failedToQueryElements(error):
                        return logFailedToQueryElements(
                            error: error
                        )
                    case let .queryWasPerformed(
                        resolvedElementQuery,
                        provideViewHierarcyDescription
                    ):
                        return logQueryWasPerformed(
                            resolvedElementQuery: resolvedElementQuery,
                            viewHierarchyDescription: provideViewHierarcyDescription(),
                            elementFunctionDeclarationLocation: info.elementFunctionDeclarationLocation
                        )
                    }
                }
            }
            
            return wrapper.wrappedResult
        }
    }
        
    private func logFailedToQueryElements(
        error: String
    ) -> StepLoggerResultWrapper<ResolvedElementQuery> {
        // TODO: better FileLine (should point to invocation in test)
        testFailureRecorder.recordFailure(
            description: error,
            fileLine: FileLine.current(),
            shouldContinueTest: false
        )
        
        // TODO: Get rid of ElementQueryResolvingState, it is only a kludge for XCUI
        let emptyState = ElementQueryResolvingState()
        emptyState.start()
        emptyState.stop()
        
        let emptyQuery = ResolvedElementQuery(
            elementQueryResolvingState: emptyState
        )
        
        return StepLoggerResultWrapper(
            stepLogAfter: StepLogAfter(
                date: dateProvider.currentDate(),
                wasSuccessful: false,
                attachments: []
            ),
            wrappedResult: emptyQuery
        )
    }
    
    private func logQueryWasPerformed(
        resolvedElementQuery: ResolvedElementQuery,
        viewHierarchyDescription: String,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation
    ) -> StepLoggerResultWrapper<ResolvedElementQuery> {
        return StepLoggerResultWrapper(
            stepLogAfter: StepLogAfter(
                date: dateProvider.currentDate(),
                wasSuccessful: resolvedElementQuery.elementWasFound,
                attachments: attachmentsForLog(
                    resolvedElementQuery: resolvedElementQuery,
                    viewHierarchyDescription: viewHierarchyDescription,
                    elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
                )
            ),
            wrappedResult: resolvedElementQuery
        )
    }
    
    private func attachmentsForLog(
        resolvedElementQuery: ResolvedElementQuery,
        viewHierarchyDescription: String,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation
    ) -> [Attachment] {
        var attachments = [Attachment]()
        
        if let candidatesDescription = resolvedElementQuery.candidatesDescription() {
            attachments.append(
                Attachment(
                    name: "Кандидаты",
                    content: .text(candidatesDescription.description)
                )
            )
            attachments.append(
                Attachment(
                    name: "Иерархия вьюх",
                    content: .text(
                        viewHierarchyDescription
                    )
                )
            )
            attachments.append(
                Attachment(
                    name: "Строка и файл где объявлен локатор",
                    content: .text(
                        """
                        \(elementFunctionDeclarationLocation.fileLine.file):\(elementFunctionDeclarationLocation.fileLine.line):
                        \(elementFunctionDeclarationLocation.function)
                        """
                    )
                )
            )
            if let screenshot = try? applicationScreenshotTaker.takeApplicationScreenshot() {
                attachments.append(
                    Attachment(
                        name: "Скриншот",
                        content: .screenshot(screenshot)
                    )
                )
            }
            attachments.append(
                contentsOf: candidatesDescription.attachments
            )
        }
        
        return attachments
    }
}
