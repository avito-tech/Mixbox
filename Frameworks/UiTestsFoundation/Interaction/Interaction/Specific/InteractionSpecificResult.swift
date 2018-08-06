public enum InteractionSpecificResult {
    case success
    case failure(InteractionSpecificFailure)
    
    public static func failureWithMessage(_ message: String) -> InteractionSpecificResult {
        return InteractionSpecificResult.failure(
            InteractionSpecificFailure(message: message)
        )
    }
}
