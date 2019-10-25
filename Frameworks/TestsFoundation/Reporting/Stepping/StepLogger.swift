import MixboxTestsFoundation
import MixboxFoundation

// How to add logging to your existing code:
//
// let myResult: MyResult = getMyResult()
// return myResult
//
// You can wrap it into logged step:
//
// let myResult: MyResult = stepLogger.logStep(stepLogBefore: StepLogBefore(...)) {
//     let myResult = getMyResult()
//     return StepLoggerResultWrapper(
//         stepLogAfter: StepLogAfter(...),
//         wrappedResult: myResult
//     )
// }
//
// Note that the result is still same. No need to change other code.
//
public protocol StepLogger: class {
    // Returns StepLoggerResultWrapper<T> instead of T, because it is easier to nest one logger into another
    // and intercept all data.
    
    func logStep<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerResultWrapper<T>)
        -> StepLoggerResultWrapper<T>
}

extension StepLogger {
    // For simple logging (without nested steps)
    public func logEntry(
        date: Date,
        title: String,
        customData: AnyEquatable = .void,
        attachments: [Attachment] = [])
    {
        let stepLogBefore = StepLogBefore(
            date: date,
            title: title,
            customData: customData,
            attachments: attachments
        )
        
        _ = logStep(stepLogBefore: stepLogBefore) { () -> StepLoggerResultWrapper<()> in
            StepLoggerResultWrapper(
                stepLogAfter: StepLogAfter(
                    date: date,
                    wasSuccessful: true,
                    customData: .void,
                    attachments: []
                ),
                wrappedResult: ()
            )
        }
    }
}
