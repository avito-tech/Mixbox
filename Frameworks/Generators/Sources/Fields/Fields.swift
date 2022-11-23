#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

// Fields is used to populate fields of object with minimal boilerplate (as in InitializableWithFields).
// Logic of getting specific field can also be reused (e.g. as in DynamicLookupGenerator).
//
@dynamicMemberLookup
open class Fields<T> {
    public typealias GeneratedType = T
    
    public init() {
    }
    
    open subscript<FieldType>(
        dynamicMember keyPath: KeyPath<GeneratedType, FieldType>)
        -> FailableProperty<FieldType>
    {
        return FailableProperty {
            let message: String
            let typeOfSelf = type(of: self)
            
            if typeOfSelf == Fields<T>.self {
                message = "`Fields<T>` must be subclassed and `subscript(dynamicMember:)` must be implemented (T == \(T.self))"
            } else {
                message = "Type `\(typeOfSelf)` doesn't override `subscript(dynamicMember:)` (T == \(T.self))"
            }
            
            throw GeneratorError(message)
        }
    }
}

#endif
