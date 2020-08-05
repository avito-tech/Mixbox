#if MIXBOX_ENABLE_IN_APP_SERVICES

// Register this in DI to be able to generate class by Fields:
//
// ```
// ByFieldsGenerator { fields in
//     MyEntity(myField: fields.myField)
// }
// ```
//
// You can also override this class. It is useful for huge models, because you can extract
// a clas into a separate file:
//
// ```
// final class MyEntityByFieldsGenerator: ByFieldsGenerator<MyEntity> {
//     init() {
//         super.init { fields in
//             Self.generateByFields(fields: fields)
//         }
//     }
//
//     private static func generateByFields(fields: Fields<MyEntity>) -> MyEntity {
//         return MyEntity(
//             myField: fields.myField
//         )
//     }
// }
// ```
//
// or alternatively:
//
// ```
// final class MyEntityByFieldsGenerator: ByFieldsGenerator<MyEntity> {
//     init() {
//         super.init { fields in
//             MyEntity(
//                 myField: fields.myField
//             )
//         }
//     }
// }
// ```
//
open class ByFieldsGenerator<T> {
    public typealias GenerateFunction = (Fields<T>) -> T
    
    private var generateFunction: GenerateFunction
    
    public init(generateFunction: @escaping GenerateFunction) {
        self.generateFunction = generateFunction
    }
    
    public final func generate(fields: Fields<T>) -> T {
        return generateFunction(fields)
    }
}

#endif
