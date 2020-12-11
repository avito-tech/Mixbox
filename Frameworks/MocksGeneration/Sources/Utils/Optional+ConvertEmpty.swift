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
