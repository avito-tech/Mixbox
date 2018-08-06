// Just to help not forget about specific EarlGrey cases.
enum EarlGreyDisambiguatedInteractionResult<T> {
    case success(T)
    case indexOutOfBoundsError(NSError)
    case elementNotFoundError(NSError)
    case otherError(NSError)
    
    func mapSuccess<U>(_ conversion: (T) -> EarlGreyDisambiguatedInteractionResult<U>)
        -> EarlGreyDisambiguatedInteractionResult<U>
    {
        switch self {
        case .success(let t):
            return conversion(t)
            
        case .indexOutOfBoundsError(let error):
            return .indexOutOfBoundsError(error)
            
        case .elementNotFoundError(let error):
            return .elementNotFoundError(error)
            
        case .otherError(let error):
            return .otherError(error)
        }
    }
}
