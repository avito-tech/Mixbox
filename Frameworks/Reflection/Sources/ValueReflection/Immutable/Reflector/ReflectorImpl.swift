public final class ReflectorImpl: Reflector {
    public let value: Any
    public let mirror: Mirror
    
    public final class Parent: Hashable {
        public let objectIdentifier: ObjectIdentifier
        public let mirror: Mirror
        
        public init(
            objectIdentifier: ObjectIdentifier,
            mirror: Mirror)
        {
            self.objectIdentifier = objectIdentifier
            self.mirror = mirror
        }
        
        public static func ==(lhs: Parent, rhs: Parent) -> Bool {
            return lhs.objectIdentifier == rhs.objectIdentifier
                && Mirror.equals(lhs: lhs.mirror, rhs: rhs.mirror, withCustomMirror: true)
        }
        
        public func hash(into hasher: inout Hasher) {
            // Note that some collisions may arise by lack of having mirror hashed, however,
            // hashing mirror has very strong negative impact on performance.
            hasher.combine(objectIdentifier)
        }
    }
    
    // Represents stack, current path in a tree representing an object.
    // Is used to break recursion when object is referencing itself (also indirectly).
    public let parents: Set<Parent>
    
    public init(
        value: Any,
        mirror: Mirror,
        parents: Set<Parent>)
    {
        self.value = value
        self.mirror = mirror
        self.parents = parents
    }
    
    public func nestedValueReflection(value: Any, mirror: Mirror) -> TypedImmutableValueReflection {
        let nextParents: Set<Parent>
        
        // Note that `as? AnyObject` always succeeds (SE-0116) and returns
        // bridged type, so it can't be used as an indicator that value is reference type.
        let isReferenceType = type(of: value) is AnyObject
        if isReferenceType {
            let objectIdentifier = ObjectIdentifier(value as AnyObject)
            
            let currentValueAsParent = Parent(
                objectIdentifier: objectIdentifier,
                mirror: mirror
            )
            
            if parents.contains(currentValueAsParent) {
                return .circularReference(value: value, mirror: mirror)
            } else {
                nextParents = parents.union([currentValueAsParent])
            }
        } else {
            nextParents = parents
        }
        
        let reflectionCase = self.reflectionCase(
            displayStyle: mirror.displayStyle
        )
        
        let reflector = ReflectorImpl(
            value: value,
            mirror: mirror,
            parents: nextParents
        )
        
        return reflectionCase.provideReflection(
            reflector: reflector
        )
    }
    
    private final class ReflectionCase {
        private let provideReflectionClosure: (Reflector) -> TypedImmutableValueReflection
        
        init<T: ReflectableWithReflector>(
            _ reflectableWithReflectorType: T.Type,
            _ typedReflectionProvider: @escaping (T) -> TypedImmutableValueReflection)
        {
            self.provideReflectionClosure = {
                typedReflectionProvider(T.reflect(reflector: $0))
            }
        }
        
        func provideReflection(reflector: Reflector) -> TypedImmutableValueReflection {
            return provideReflectionClosure(reflector)
        }
    }
    
    private func reflectionCase(
        displayStyle: Mirror.DisplayStyle?)
        -> ReflectionCase
    {
        let map: [Mirror.DisplayStyle: ReflectionCase] = [
            .`struct`: .init(StructImmutableValueReflection.self, { .`struct`($0) }),
            .`class`: .init(ClassImmutableValueReflection.self, { .`class`($0) }),
            .`enum`: .init(EnumImmutableValueReflection.self, { .`enum`($0) }),
            .tuple: .init(TupleImmutableValueReflection.self, { .tuple($0) }),
            .optional: .init(OptionalImmutableValueReflection.self, { .optional($0) }),
            .collection: .init(CollectionImmutableValueReflection.self, { .collection($0) }),
            .dictionary: .init(DictionaryImmutableValueReflection.self, { .dictionary($0) }),
            .set: .init(SetImmutableValueReflection.self, { .set($0) })
        ]
        
        return displayStyle.flatMap { map[$0] }
            ?? .init(PrimitiveImmutableValueReflection.self, { .primitive($0) })
    }
}

extension Mirror {
    fileprivate static func equals(lhs: Mirror, rhs: Mirror, withCustomMirror: Bool) -> Bool {
        switch (lhs.superclassMirror, rhs.superclassMirror) {
        case let (lhs?, rhs?):
            return Mirror.equals(lhs: lhs, rhs: rhs, withCustomMirror: true)
        case (nil, nil):
            break
        case (nil, _?), (_?, nil):
            return false
        }
        
        // Custom mirror can be same mirror as self.
        // Here we break recursion by passing `withCustomMirror: false`
        if withCustomMirror && !Mirror.equals(lhs: lhs.customMirror, rhs: rhs.customMirror, withCustomMirror: false) {
            return false
        }
        
        return lhs.displayStyle == rhs.displayStyle
            && lhs.subjectType == rhs.subjectType
            && lhs.children.elementsEqual(rhs.children) { (lhs, rhs) in
                lhs.label == rhs.label
            }
    }
}
