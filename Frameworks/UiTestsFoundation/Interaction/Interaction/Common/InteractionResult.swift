public enum InteractionResult {
    case success
    case failure(InteractionFailure)
    
    public var wasSuccessful: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var wasFailed: Bool {
        return !wasSuccessful
    }
    
    public var failure: InteractionFailure? {
        switch self {
        case .success:
            return nil
        case .failure(let failure):
            return failure
        }
    }
}
