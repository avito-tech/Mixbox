#if MIXBOX_ENABLE_IN_APP_SERVICES

/// Used to generate values of types that are not known at compile time.
///
/// Explanation:
///
/// `AnyGenerator` is not really an `Any` generator, it's more like `T` generator,
/// because its signature is `func generate<T>() throws -> T`
///
/// Sometimes you may need a generation of values purely by type from runtime, not some
/// static type `T` that is avaliable at compile time.
///
/// To implement such functionality there are two ways:
///
/// - Support runtime types in AnyGenerator.
///
///     This can done by injecting type value like this:
///
///     ```
///     func generate<T>(type: T.Type) throws -> T
///     ```
///
///     But implementation (`AnyGeneratorImpl`) uses generic types like `Generator<T>`
///     and there is no way to create generic in runtime (you need to specialize it,
///     meaning to call use it with generic parameter of known type).
///
///     So we need to use following code:
///
///     ```
///     func generate<T>(generatedType: T.Type, generatorType: Generator<T>.Type) throws -> T
///     ```
///
///     You can already notice that interface starts to depend on implementation, which is alone
///     a bad design pattern. And it's not even whole solution, because you also need type of
///     `ByFieldsGenerator<T>`, and maybe something else.
///
///     This solution violates IoC and also requires you to specialize every Generator<T>
///     or other generic, makes interfaces depend on implementation.
///
/// - Specialize function from the interface for every known type.
///
///     This method doesn't violate IoC pattern, however, it still has drawbacks (but same drawbacks
///     as in previous solution): you need to specialize generics.
///
///     `TypeErasedAnyGeneratorImpl` use set of specializations of `AnyGenerator.generate()` function
///     and select specialiation by type
///
///     The method doesn't violate IoC, because only interface is used, not the implementation.
///
///     This is the method that is currently used.
///
///     You may think that we can get rid of generics completely, and thus get rid of the need
///     of specializing anything, but the code is heavy on generics and I don't think it's
///     theoretically possible to get rid of them and get same user interface of generators.
///
///     The task of making a list of all known types can be done by code generation.
///     This is how it is used in Mixbox Mocks.
///

public protocol TypeErasedAnyGenerator {
    func generate(type: Any.Type) throws -> Any
}

#endif
