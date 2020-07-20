// Fields is used to populate fields of object with minimal boilerplate (as in InitializableWithFields).
// Logic of getting specific field can also be reused (e.g. as in DynamicLookupGenerator).
//
@dynamicMemberLookup
public final class Fields<T> {
    public typealias GeneratedType = T
    
    private let generatorByKeyPath: GeneratorByKeyPath<GeneratedType>
    
    public init(generatorByKeyPath: GeneratorByKeyPath<GeneratedType>) {
        self.generatorByKeyPath = generatorByKeyPath
    }
    
    public subscript<FieldType>(dynamicMember keyPath: KeyPath<GeneratedType, FieldType>) -> FieldType {
        let generator: Generator<FieldType> = generatorByKeyPath[keyPath]
        
        do {
            return try generator.generate()
        } catch {
            let message = String(describing: error)
            
            let exception = NSException(
                name: NSExceptionName(rawValue: "FieldsException"),
                reason: message,
                userInfo: nil
            )
            
            exception.raise()
            fatalError(message)
        }
    }
}
