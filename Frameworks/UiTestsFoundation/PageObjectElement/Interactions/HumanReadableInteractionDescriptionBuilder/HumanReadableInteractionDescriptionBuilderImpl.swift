public final class HumanReadableInteractionDescriptionBuilderImpl: HumanReadableInteractionDescriptionBuilder {
    public typealias BuildFunction = (HumanReadableInteractionDescriptionBuilderSource) -> (String)
    
    public var buildFunction: BuildFunction
    
    public init(buildFunction: @escaping BuildFunction) {
        self.buildFunction = buildFunction
    }
    
    public func description(info: HumanReadableInteractionDescriptionBuilderSource) -> String {
        return buildFunction(info)
    }
}
