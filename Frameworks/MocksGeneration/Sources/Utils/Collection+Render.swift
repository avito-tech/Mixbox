extension Collection {
    public func render(
        separator: String,
        valueIfEmpty: String? = nil,
        surround: (String) throws -> String,
        transform: (Int, Iterator.Element) throws -> String)
        rethrows
        -> String
    {
        if isEmpty, let valueIfEmpty = valueIfEmpty {
            return valueIfEmpty
        } else {
            return try surround(
                enumerated().map(transform).joined(separator: separator)
            )
        }
    }
}
