extension Optional {
    public func descriptionOrNil() -> String {
        if let unwrapped = self {
            return "\(unwrapped)"
        } else {
            return "nil"
        }
    }
}
