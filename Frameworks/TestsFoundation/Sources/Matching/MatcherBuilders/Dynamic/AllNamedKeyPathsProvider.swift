/// Exposes all field names and keypaths of a single type.
/// Should not expose fields recursively, only those defined within this type declaration.
///
/// Usage (with convenent builder):
///
/// ```
/// struct MyStruct: AllNamedKeyPathsProvider {
///     let a: Int
///     let b: Int
///
///     static var allNamedKeyPaths: NamedKeyPaths<Self> {
///         NamedKeyPaths {
///             $0.a = "a"
///             $0.b = "b"
///         }
///     }
/// }
/// ```
///
/// Usage (without builder):
///
/// ```
/// struct MyStruct: AllNamedKeyPathsProvider {
///     let a: Int
///     let b: Int
///
///     static var allNamedKeyPaths: NamedKeyPaths<Self> {
///         NamedKeyPaths(
///             keyPathByName: [
///                 "a": \MyStruct.a,
///                 "b": \MyStruct.b,
///             ]
///         )
///     }
/// }
/// ```
///
/// Of course, you can also place code of the conformance to `AllNamedKeyPathsProvider` in an extension.
///
public protocol AllNamedKeyPathsProvider {
    static var allNamedKeyPaths: NamedKeyPaths<Self> { get }
}
