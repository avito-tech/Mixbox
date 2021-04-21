import MixboxFoundation

extension FieldBuilderProperty {
    public func callAsFunction<Customizable>(
        _ value: Customizable)
        -> T.Result
        where Field == CustomizableScalar<Customizable>
    {
        return callAsFunction(.customized(value))
    }
}
