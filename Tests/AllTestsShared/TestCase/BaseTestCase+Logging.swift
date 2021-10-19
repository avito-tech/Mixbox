import MixboxTestsFoundation

extension BaseTestCase {
    func logBlock<T>(
        text: String,
        body: () -> T
    ) -> T {
        stepLogger.logStep(
            stepLogBefore: StepLogBefore(
                date: Date(),
                title: text
            ),
            body: {
                StepLoggerResultWrapper(
                    stepLogAfter: StepLogAfter(
                        date: Date(),
                        wasSuccessful: true
                    ),
                    wrappedResult: body()
                )
            }
        ).wrappedResult
    }
    
    func logMessage(
        text: String
    ) {
        stepLogger.logEntry(date: Date(), title: text)
    }
}
