public enum BuilderType {
    case stubbing
    case verification
    
    public func builderClassName() -> String {
        switch self {
        case .stubbing:
            return "StubbingBuilder"
        case .verification:
            return "VerificationBuilder"
        }
    }
    
    public func builderBaseClassName() -> String {
        switch self {
        case .stubbing:
            return "StubbingBuilder"
        case .verification:
            return "VerificationBuilder"
        }
    }
    
    public func propertyBuilderClassName(isMutable: Bool) -> String {
        switch (self, isMutable) {
        case (.stubbing, true):
            return "StubbingMutablePropertyBuilder"
        case (.stubbing, false):
            return "StubbingImmutablePropertyBuilder"
        case (.verification, true):
            return "VerificationMutablePropertyBuilder"
        case (.verification, false):
            return "VerificationImmutablePropertyBuilder"
        }
    }
}
