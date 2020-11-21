public final class GenericParameter {
    public let name: String
    public let constraint: String?
    
    public init(name: String, constraint: String?) {
        self.name = name
        self.constraint = constraint
    }
    
    public var nameWithConstraint: String {
        [name, constraint.map { "\($0)" }]
            .compactMap { $0 }
            .joined(separator: ": ")
    }
}
