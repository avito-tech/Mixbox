public final class CGSizePropertyMatcherBuilder<TargetMatcherArgumentT>: PropertyMatcherBuilder<TargetMatcherArgumentT, CGSize> {
    public var width: MappingMatcherBuilderImpl<TargetMatcherArgumentT, CGFloat> {
        return nested("width", { $0.width })
    }
    
    public var height: MappingMatcherBuilderImpl<TargetMatcherArgumentT, CGFloat> {
        return nested("height", { $0.height })
    }
}
