/// Utility that can be used to create builders that modify fields.
///
/// Example:
///
/// ```
/// struct MyStruct {
///     var x: Int
///
///     ...
///
///     var with: FieldBuilder<StructureFieldBuilderCallImplementation<Self>> {
///         return FieldBuilder(
///             callImplementation: StructureFieldBuilderCallImplementation(
///                 structure: self
///             )
///         )
///     }
/// }
///
/// ...
///
/// let myNewStruct = myOldStruct.with.x(42)
/// ```
///
/// It can be configured with different `FieldBuilderCallImplementation`.
///
/// For example, you can set up properties of a nested (on an arbiitrary level) structure in
/// a class using `SubstructureFieldBuilderCallImplementation`:
///
/// ```
/// element.with.timeout(15)
/// ```
///
@dynamicMemberLookup
public final class FieldBuilder<T: FieldBuilderCallImplementation> {
    private let callImplementation: T
    
    public init(
        callImplementation: T)
    {
        self.callImplementation = callImplementation
    }
    
    public subscript<Field>(
        dynamicMember keyPath: WritableKeyPath<T.Structure, Field>)
        -> FieldBuilderProperty<T, Field>
    {
        return FieldBuilderProperty(
            keyPath: keyPath,
            callImplementation: callImplementation
        )
    }
}
