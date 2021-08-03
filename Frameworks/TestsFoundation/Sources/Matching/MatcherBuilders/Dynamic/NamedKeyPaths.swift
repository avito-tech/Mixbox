/// Key paths by name from a concrete `Root` type to any resulting value type.
///
public final class NamedKeyPaths<Root> {
    @dynamicMemberLookup
    public class KeyPathsBuilder {
        fileprivate var nameByKeyPath = [PartialKeyPath<Root>: String]()
        
        public subscript<PropertyType>(
            dynamicMember keyPath: KeyPath<Root, PropertyType>)
            -> String?
        {
            get {
                return nameByKeyPath[keyPath]
            }
            set {
                nameByKeyPath[keyPath] = newValue
            }
        }
    }
    
    private let keyPathByName: [String: PartialKeyPath<Root>]
    private let nameByKeyPath: [PartialKeyPath<Root>: String]
    
    public init(keyPathByName: [String: PartialKeyPath<Root>]) {
        self.keyPathByName = keyPathByName
        self.nameByKeyPath = Self.invertKeysAndValues(dictionary: keyPathByName)
    }
    
    public init(nameByKeyPath: [PartialKeyPath<Root>: String]) {
        self.keyPathByName = Self.invertKeysAndValues(dictionary: nameByKeyPath)
        self.nameByKeyPath = nameByKeyPath
    }
    
    /// Example:
    ///
    /// ```
    /// NamedKeyPaths<CGRect> {
    ///     $0.origin = "origin"
    ///     $0.size = "size"
    /// }
    /// ```
    ///
    public convenience init(build: (KeyPathsBuilder) -> ()) {
        let builder = KeyPathsBuilder()
        
        build(builder)
        
        self.init(nameByKeyPath: builder.nameByKeyPath)
    }
    
    public func name(keyPath: PartialKeyPath<Root>) -> String? {
        return nameByKeyPath[keyPath]
    }
    
    public func keyPath(name: String) -> PartialKeyPath<Root>? {
        return keyPathByName[name]
    }
    
    private static func invertKeysAndValues<K: Hashable, V: Hashable>(dictionary: [K: V]) -> [V: K] {
        var inverted = [V: K]()
        
        for (k, v) in dictionary {
            inverted[v] = k
        }
        
        return inverted
    }
}
