open class Matcher<T> {
    public private(set) lazy var description = descriptionClosure()
    private let matchingFunction: (T) -> MatchingResult
    private let descriptionClosure: () -> String
    
    public init(
        description: @escaping () -> String,
        matchingFunction: @escaping (T) -> MatchingResult)
    {
        self.descriptionClosure = description
        self.matchingFunction = matchingFunction
    }
    
    public func match(value: T) -> MatchingResult {
        return matchingFunction(value)
    }
}
