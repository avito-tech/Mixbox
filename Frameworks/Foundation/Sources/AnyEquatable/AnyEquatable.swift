#if MIXBOX_ENABLE_IN_APP_SERVICES

// TODO: SRP? To separate CustomDebugStringConvertible & Equatable
//       It can be done by converting to protocols, using protocol extensions and some sorcery.
//       To be able to do such things:
//
//           var x: AnyEquatable & AnyCustomDebugStringConvertible & AnyComparable
//
public final class AnyEquatable: CustomDebugStringConvertible, Equatable {
    public typealias EqualsFunction = (_ other: Any) -> Bool
    public typealias DebugDescriptionFunction = () -> String
    
    public let value: Any
    
    private let equalsFunction: EqualsFunction
    private let debugDescriptionFunction: DebugDescriptionFunction
    
    public static let void = AnyEquatable(
        value: Void(),
        equals: { _ in true },
        debugDescription: { "Void()" }
    )
    
    public init(
        value: Any,
        equals: @escaping EqualsFunction,
        debugDescription: @escaping DebugDescriptionFunction)
    {
        self.value = value
        self.equalsFunction = equals
        self.debugDescriptionFunction = debugDescription
    }
    
    public convenience init<T>(
        value: T)
        where
        T: Equatable,
        T: CustomDebugStringConvertible
    {
        self.init(
            value: value,
            equals: { other in
                other as? T == value
            },
            debugDescription: {
                value.debugDescription
            }
        )
    }
    
    public var debugDescription: String {
        return debugDescriptionFunction()
    }
    
    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.equalsFunction(rhs)
    }
}

#endif
