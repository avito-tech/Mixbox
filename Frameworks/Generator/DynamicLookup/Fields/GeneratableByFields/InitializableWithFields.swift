// `InitializableWithFields` and `GeneratableByFields` are used to automatically resolve DynamicLookupGenerator
// generators without requiring user to register them in DI. This is done via `DefaultGeneratorProvider`.
//
// They are designed to minimaize boilerplate.
//
// If it is okay for you to have a required init in your model, you can use `InitializableWithFields`:
//
// ```
// final class MyModel: InitializableWithFields {                    //   <---  Code to be added
//     let myField: Int
//
//     init(fields: Fields<Self>) {                                  //   <---  Code to be added
//          myField = fields.myField                                 //   <---  Code to be added
//     }                                                             //   <---  Code to be added
// }
// ```
//
// This is a complete code that allows you to generate `MyModel` dynamically.
//
// If you don't want to have init, you can use `GeneratableByFields` instead:
//
// ```
// final class MyModel: GeneratableByFields {                        //   <---  Code to be added
//     let myField: Int
//
//     init(myField: Int) {
//          self.myField = myField
//     }
//
//     static func generate(fields: Fields<MyModel>) -> MyModel {    //   <---  Code to be added
//          return MyModel(                                          //   <---  Code to be added
//              myField: fields.myField                              //   <---  Code to be added
//          )                                                        //   <---  Code to be added
//     }                                                             //   <---  Code to be added
// }
// ```
//
public protocol InitializableWithFields: GeneratableByFields {
    init(fields: Fields<Self>)
}

extension InitializableWithFields {
    public static func byFieldsGenerator() -> ByFieldsGenerator<Self> {
        return ByFieldsGenerator<Self> { fields in
            Self(fields: fields)
        }
    }
}
