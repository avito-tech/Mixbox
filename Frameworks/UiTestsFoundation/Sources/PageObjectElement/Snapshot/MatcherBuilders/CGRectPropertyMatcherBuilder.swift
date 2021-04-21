import MixboxTestsFoundation

public final class CGRectPropertyMatcherBuilder<TargetMatcherArgument>:
    PropertyMatcherBuilder<TargetMatcherArgument, CGRect>
{
    public var origin: CGPointPropertyMatcherBuilder<TargetMatcherArgument> {
        return nested("origin", { $0.origin }, CGPointPropertyMatcherBuilder.init)
    }

    public var size: CGSizePropertyMatcherBuilder<TargetMatcherArgument> {
        return nested("size", { $0.size }, CGSizePropertyMatcherBuilder.init)
    }
}
