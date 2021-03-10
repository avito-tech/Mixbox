public final class ArrayPropertyMatcherBuilder<Container, Element: Equatable, MatcherBuilder> {
    private let propertyName: String
    private let propertyGetter: (Container) -> ([Element])
    private let matcherBuilder: () -> (MatcherBuilder)
    
    public init(
        propertyName: String,
        propertyGetter: @escaping (Container) -> ([Element]),
        matcherBuilder: @escaping @autoclosure () -> (MatcherBuilder))
    {
        self.propertyName = propertyName
        self.propertyGetter = propertyGetter
        self.matcherBuilder = matcherBuilder
    }
    
    public convenience init(
        propertyName: String,
        propertyKeyPath: KeyPath<Container, [Element]>,
        matcherBuilder: @escaping @autoclosure () -> (MatcherBuilder))
    {
        self.init(
            propertyName: propertyName,
            propertyGetter: { $0[keyPath: propertyKeyPath] },
            matcherBuilder: matcherBuilder()
        )
    }
    
    public func contains(where buildMatcher: (MatcherBuilder) -> Matcher<Element>) -> Matcher<Container> {
        return HasPropertyMatcher(
            property: propertyGetter,
            name: propertyName,
            matcher: ArrayContainsElementMatcher<Element>(
                matcher: buildMatcher(matcherBuilder())
            )
        )
    }
    
    public static func ==(this: ArrayPropertyMatcherBuilder, expectedValue: [Element]) -> Matcher<Container> {
        return HasPropertyMatcher(
            property: this.propertyGetter,
            name: this.propertyName,
            matcher: EqualsMatcher(expectedValue)
        )
    }
    
    public func map<SubElement>(transform: @escaping (Element) -> SubElement) -> ArrayPropertyMatcherBuilder<Container, SubElement, Void> {
        return ArrayPropertyMatcherBuilder<Container, SubElement, Void>(
            propertyName: propertyName,
            propertyGetter: { [propertyGetter] container in propertyGetter(container).map(transform) },
            matcherBuilder: Void()
        )
    }
}
