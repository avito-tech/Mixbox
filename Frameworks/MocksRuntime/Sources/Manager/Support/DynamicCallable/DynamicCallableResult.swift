public enum DynamicCallableResult<ReturnValue> {
    // `returned` and `threw` are both positive cases.
    // Because functions can either return value or throw error.
    case returned(ReturnValue)
    case threw(Error)
    
    // The negative case is `canNotProvideResult`. Can be used
    // if no result can be provided based on given inputs.
    case canNotProvideResult(Error)
}
