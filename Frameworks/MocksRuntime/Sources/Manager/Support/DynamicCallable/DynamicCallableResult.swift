public enum DynamicCallableResult<ReturnValue> {
    // `returned` and `threw` are both positive cases.
    // Because functions can either return value or throw error.
    case returned(ReturnValue)
    // This case will be nice to have in the near future:
    // case .threw(Error)
    
    // The negative case is `canNotProvideResult`. Can be used
    // if no result can be provided based on given inputs.
    case canNotProvideResult(Error)
}
