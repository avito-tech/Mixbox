/// Represent an argument to a function that is a closure.
/// It is a real closure that can be created in your real application.
///
/// Example. In your app you have this:
///
/// ```
/// myService.getData(completion: { myData in someProductionCode(myData) })
/// ```
///
/// `CallableClosureArgument` will represent `completion` and calling it will call `someProductionCode`.
///
/// If `CallableClosureArgument` is called with `CallableClosureArgumentArguments.automatic`
/// then `myData` argument will be created automatically.
///
/// The class is designed to make it easy to customize `ClosureArgumentsHandler`.
/// You can simply call it with some arguments (or say that they shoul bee generated automatically).
///
/// Note that return value is ignored, because mocks don't really use it.
public protocol AnyGeneratorDynamicCallableClosureArgument {
    var name: String? { get }
    var label: String? { get }
    var type: Any.Type { get }
    var isNil: Bool { get }
    var argumentTypes: [Any.Type] { get }
    var returnValueType: Any.Type { get }
    
    // At the moment `throws` here means only some internal errors
    // and doesn't represent behavior of a closure, only behavior of this framework.
    func call<ReturnValue>(
        arguments: CustomizableArray<Any>)
        throws
        -> ThrowingFunctionResult<ReturnValue>
}
