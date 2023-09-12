#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class TrackedIdlingResourceDescription {
    public let name: String
    public let causeOfResourceBeingTracked: String
    public let likelyCauseOfResourceStillBeingTracked: String
    public let listOfConditionsThatWillCauseResourceToBeUntracked: [String]
    public let customProperties: [(key: String, value: String)]
    
    public init(
        name: String,
        causeOfResourceBeingTracked: String,
        likelyCauseOfResourceStillBeingTracked: String,
        listOfConditionsThatWillCauseResourceToBeUntracked: [String],
        customProperties: [(key: String, value: String)] = []
    ) {
        self.name = name
        self.causeOfResourceBeingTracked = causeOfResourceBeingTracked
        self.likelyCauseOfResourceStillBeingTracked = likelyCauseOfResourceStillBeingTracked
        self.listOfConditionsThatWillCauseResourceToBeUntracked = listOfConditionsThatWillCauseResourceToBeUntracked
        self.customProperties = customProperties
    }
}

#endif
