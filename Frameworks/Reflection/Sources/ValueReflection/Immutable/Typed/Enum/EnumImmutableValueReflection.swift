// https://github.com/apple/swift/blob/aa3e5904f8ba8bf9ae06d96946774d171074f6e5/stdlib/public/core/OutputStream.swift
@_silgen_name("swift_EnumCaseName")
private func _getEnumCaseName<T>(_ value: T) -> UnsafePointer<CChar>?

public final class EnumImmutableValueReflection:
    ImmutableValueReflection,
    ReflectableWithReflector
{
    public let type: Any.Type
    public let caseName: String?
    public let associatedValue: TypedImmutableValueReflection?
    
    public init(
        type: Any.Type,
        caseName: String?,
        associatedValue: TypedImmutableValueReflection?)
    {
        self.type = type
        self.caseName = caseName
        self.associatedValue = associatedValue
    }
    
    public static func reflect(reflector: Reflector) -> EnumImmutableValueReflection {
        return EnumImmutableValueReflection(
            type: reflector.mirror.subjectType,
            caseName: enumCaseName(
                child: reflector.mirror.children.first,
                reflected: reflector.value
            ),
            associatedValue: reflector.mirror.children.first.map { child in
                reflector.nestedValueReflection(
                    value: child.value
                )
            }
        )
    }
    
    private static func enumCaseName(
        child: Mirror.Child?,
        reflected: Any)
        -> String?
    {
        let realEnumCaseName = _getEnumCaseName(reflected).map {
            String(cString: $0)
        }
        
        return realEnumCaseName ?? child?.label
    }
}
