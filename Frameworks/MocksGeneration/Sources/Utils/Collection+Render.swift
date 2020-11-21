extension Collection where Element == String {
    public func render(
        separator: String,
        valueIfEmpty: String? = nil,
        surround: (String) throws -> String)
        rethrows
        -> String
    {
        try render(
            separator: separator,
            valueIfEmpty: valueIfEmpty,
            surround: surround,
            transform: { (_, element) in
                element
            }
        )
    }
}

extension Collection {
    public func render(
        separator: String,
        valueIfEmpty: String? = nil,
        surround: (String) throws -> String,
        flatTransform: (Int, Iterator.Element) throws -> [String])
        rethrows
        -> String
    {
        if isEmpty, let valueIfEmpty = valueIfEmpty {
            return valueIfEmpty
        } else {
            return try surround(
                enumerated()
                    .flatMap(flatTransform)
                    .joined(separator: separator)
            )
        }
    }
    
    public func render(
        separator: String,
        valueIfEmpty: String? = nil,
        surround: (String) throws -> String,
        transform: (Int, Iterator.Element) throws -> String)
        rethrows
        -> String
    {
        try render(
            separator: separator,
            valueIfEmpty: valueIfEmpty,
            surround: surround,
            flatTransform: { (index, element) in
                [try transform(index, element)]
            }
        )
    }
    
    public func render(
        separator: String,
        valueIfEmpty: String? = nil,
        transform: (Int, Iterator.Element) throws -> String)
        rethrows
        -> String
    {
        try render(
            separator: separator,
            valueIfEmpty: valueIfEmpty,
            surround: { $0 },
            transform: transform
        )
    }
}
