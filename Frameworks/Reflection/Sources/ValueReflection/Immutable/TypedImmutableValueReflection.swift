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
    
    public var type: Any.Type {
        return associatedValue.type
    }
    
    public static func reflect(reflected: Any) -> TypedImmutableValueReflection {
        return reflect(reflected: reflected, mirror: Mirror(reflecting: reflected))
    }
    
    public static func reflect(reflected: Any, mirror: Mirror) -> TypedImmutableValueReflection {
        guard let displayStyle = mirror.displayStyle else {
            return .primitive(
                PrimitiveImmutableValueReflection(reflected: reflected)
            )
        }
        
        switch displayStyle {
        case .`struct`:
            return .`struct`(
                StructImmutableValueReflection.reflect(mirror: mirror)
            )
        case .`class`:
            return .`class`(
                ClassImmutableValueReflection.reflect(mirror: mirror)
            )
        case .`enum`:
            return .`enum`(
                EnumImmutableValueReflection.reflect(reflected: reflected, mirror: mirror)
            )
        case .tuple:
            return .tuple(
                TupleImmutableValueReflection.reflect(mirror: mirror)
            )
        case .optional:
            return .optional(
                OptionalImmutableValueReflection.reflect(mirror: mirror)
            )
        case .collection:
            return .collection(
                CollectionImmutableValueReflection.reflect(mirror: mirror)
            )
        case .dictionary:
            return .dictionary(
                DictionaryImmutableValueReflection.reflect(mirror: mirror)
            )
        case .set:
            return .set(
                SetImmutableValueReflection.reflect(mirror: mirror)
            )
        @unknown default:
            return .primitive(
                PrimitiveImmutableValueReflection(reflected: reflected)
            )
        }
    }
    
    private var associatedValue: ImmutableValueReflection {
        switch self {
        case .`struct`(let reflection):
            return reflection
        case .`class`(let reflection):
            return reflection
        case .`enum`(let reflection):
            return reflection
        case .tuple(let reflection):
            return reflection
        case .optional(let reflection):
            return reflection
        case .collection(let reflection):
            return reflection
        case .dictionary(let reflection):
            return reflection
        case .set(let reflection):
            return reflection
        case .primitive(let reflection):
            return reflection
        }
    }
}
