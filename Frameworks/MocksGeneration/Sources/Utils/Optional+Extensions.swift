extension Optional {
    func map<T>(
        default: @autoclosure () -> T,
        transform: (Wrapped) throws -> T)
        rethrows
        -> T
    {
        return try map(transform) ?? `default`()
    }
    
    func flatMap<T>(
        default: @autoclosure () -> T,
        transform: (Wrapped) throws -> T?)
        rethrows
        -> T
    {
        return try flatMap(transform) ?? `default`()
    }
}

extension Optional where Wrapped == String {
    func convertEmptyToNil() -> String? {
        if self?.isEmpty == true {
            return nil
        } else {
            return self
        }
    }
}

extension String {
    func convertEmptyToNil() -> String? {
        if isEmpty {
            return nil
        } else {
            return self
        }
    }
}
