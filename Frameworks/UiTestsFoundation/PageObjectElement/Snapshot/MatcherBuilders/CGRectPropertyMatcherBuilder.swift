import MixboxTestsFoundation

public final class CGRectPropertyMatcherBuilder<TargetMatcherArgumentT>:
    PropertyMatcherBuilder<TargetMatcherArgumentT, CGRect>
{
    public var origin: MappingMatcherBuilderImpl<TargetMatcherArgumentT, CGPoint> {
        return nested("origin", { $0.origin })
    }
    
    public var size: MappingMatcherBuilderImpl<TargetMatcherArgumentT, CGSize> {
        return nested("size", { $0.size })
    }
}
