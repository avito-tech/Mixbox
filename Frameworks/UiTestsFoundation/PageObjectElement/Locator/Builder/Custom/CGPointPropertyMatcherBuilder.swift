public final class CGPointPropertyMatcherBuilder<TargetMatcherArgumentT>: PropertyMatcherBuilder<TargetMatcherArgumentT, CGPoint> {
    public var x: MappingMatcherBuilderImpl<TargetMatcherArgumentT, CGFloat> {
        return nested("x", { $0.x })
    }
    
    public var y: MappingMatcherBuilderImpl<TargetMatcherArgumentT, CGFloat> {
        return nested("y", { $0.y })
    }
}
