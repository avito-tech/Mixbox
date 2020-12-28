public enum TypedImmutableValueReflection: ImmutableValueReflection {
    case `struct`(StructImmutableValueReflection)
    case `class`(ClassImmutableValueReflection)
    case `enum`(EnumImmutableValueReflection)
    case tuple(TupleImmutableValueReflection)
    case optional(OptionalImmutableValueReflection)
    case collection(CollectionImmutableValueReflection)
    case dictionary(DictionaryImmutableValueReflection)
    case set(SetImmutableValueReflection)
    case primitive(PrimitiveImmutableValueReflection)
    
    // Special case if object is stored inside itself at some level in a tree.
    // Can be still reflected manually later. This case was added to
    // break infinite recursion when reflection is made.
    case circularReference(value: Any, mirror: Mirror)
    
    public var type: Any.Type {
        switch self {
        case let .`struct`(reflection):
            return reflection.type
        case let .`class`(reflection):
            return reflection.type
        case let .`enum`(reflection):
            return reflection.type
        case let .tuple(reflection):
            return reflection.type
        case let .optional(reflection):
            return reflection.type
        case let .collection(reflection):
            return reflection.type
        case let .dictionary(reflection):
            return reflection.type
        case let .set(reflection):
            return reflection.type
        case let .primitive(reflection):
            return reflection.type
        case let .circularReference(value, _):
            return Swift.type(of: value)
        }
    }
}
