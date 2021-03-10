public typealias RetriableTimedInteractionState = IsPossibleToRetryProvider
    & MarkableAsImpossibleToRetry
    & RetriableTimedInteractionStateForNestedRetryOperationProvider
