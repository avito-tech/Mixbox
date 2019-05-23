extension Optional {
    public func toArray<T>(transform: (Wrapped) throws -> [T]) rethrows -> [T] {
        return try map(transform) ?? []
    }
}
