public enum TextEditingActionMode {
    case replace
    case append
    
    static var `default`: TextEditingActionMode {
        .replace
    }
}
