// Allows to nest retries. Example in pseudocode:
//
// retryInteractionUntilTimeout { state in
//     state.markAsImpossibleToRetry()
//
//     tap()
//
//     retryInteractionUntilTimeout { state in
//         await()
//     }
// }
//
// In this example `markAsImpossibleToRetry` tells `retry` to not peform additional tap if interaction is failed
// (assuming that you don't want to mess UI with multiple taps). But if you have nested retry for some operation
// that checks something, it is okay to retry it, if there is no calls to `markAsImpossibleToRetry` in a nested retry.
//
// TODO: Write tests with fake interactions to test nesting of `RetriableTimedInteractionState`, test nesting with
// nested interations and nested calls to `retryInteractionUntilTimeout`, check all combinations of nesting and deep
// levels of nesting.
//
public protocol RetriableTimedInteractionStateForNestedRetryOperationProvider {
    func retriableTimedInteractionStateForNestedRetryOperation() -> RetriableTimedInteractionState
}
