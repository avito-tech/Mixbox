open class Matcher<MatchedType> {
    public typealias MatchedType = MatchedType
    
    public private(set) lazy var description = descriptionClosure()
    private let matchingFunction: (MatchedType) -> MatchingResult
    private let descriptionClosure: () -> String
    
    public init(
        description: @escaping () -> String,
        matchingFunction: @escaping (MatchedType) -> MatchingResult)
    {
        self.descriptionClosure = description
        self.matchingFunction = matchingFunction
    }
    
    public func match(value: MatchedType) -> MatchingResult {
        return matchingFunction(value)
    }
}
